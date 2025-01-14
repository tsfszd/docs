using NexelusApp.Service.DataAccess;
using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Service
{
    public class DocumentService<T> where T : BaseDocument, new()
    {
        private NexContext context;
        public DocumentService(NexContext _context)
        {
            this.context = _context;
        }
        public bool AddDocument(T entity, string file)
        {
            var isSucceed = false;
            var res = Upload(entity.DocumentPath, entity.DocumentName, file);
            if (res.ResponseType == DocResponseType.Success)
            {
                Repository<T> resRepository = new Repository<T>(this.context);
                isSucceed = resRepository.Save(entity);
            }
            return isSucceed;
        }
        public bool RemoveDocument(CriteriaBase<T> criteria, string path)
        {
            var isSucceed = false;
            Repository<T> resRepository = new Repository<T>(this.context);
            isSucceed = resRepository.Delete(criteria);
            if (isSucceed)
            {
                Remove(path);
            }
            return isSucceed;
        }
        public string GetDocument(CriteriaBase<T> criteria, string basePath, ref bool IsURL)
        {
            string retVal = "";
            T obj = new T();
            Repository<T> resRepository = new Repository<T>(this.context);
            var response = resRepository.Select(criteria);
            if (response != null && response.Count > 0)
            {
                obj = response.FirstOrDefault();
                string sPath = obj.DocumentLink.Replace("documents", basePath).Replace("/", "\\");
                var ext = Path.GetExtension(sPath);
                DirectoryInfo dInfo = new DirectoryInfo(sPath);
                if (ext.ToLower() == ".jpg" || ext.ToLower() == ".png"
                            || ext.ToLower() == ".jpeg"
                            || ext == ".bmp")
                {
                    //throw new Exception("The file type is not supported");
                    //sPath = "C:\\PDM\\Nexelus-1221\\Web\\documents\\2\\r8d7566de99985be\\98d7566de9f8e2c3\\Okta_SAML_Integration.png";
                    if (File.Exists(sPath))
                    {
                        using (Image origImage = Image.FromFile(sPath))
                        {
                            retVal = Convert.ToBase64String(CompressImage(origImage));
                            origImage.Dispose();
                        }
                    }
                }
                else if (ext.ToLower() == ".pdf")
                {
                    IsURL = true;
                    retVal = obj.DocumentLink;
                }
                else
                {
                    throw new Exception("The file type is not supported");
                }
            }       
            return retVal;
        }
        private DocResponse Upload(string path, string fileName, string file)
        {
            var res = new DocResponse();
            res.ResponseType = DocResponseType.Success;
            try
            {
                DirectoryInfo dirInfo = new DirectoryInfo(path);
                if (!dirInfo.Exists)
                    Directory.CreateDirectory(path);

                FileStream fs = new FileStream(path + "\\" + fileName, FileMode.Create);
                var fileBytes = Convert.FromBase64String(file);
                fs.Write(fileBytes, 0, fileBytes.Length);
                fs.Close();
                fs.Dispose();

            }
            catch (Exception ex)
            {
                res.ResponseType = DocResponseType.Error;
                res.Message = ex.Message;
            }
            return res;
        }
        private DocResponse Remove(string path)
        {
            var res = new DocResponse();
            res.ResponseType = DocResponseType.Success;
            try
            {
                if (!Directory.Exists(path))
                {
                    //No image exists
                    return res;
                }

                DirectoryInfo dInfo = new DirectoryInfo(path);

                if (dInfo.GetFiles().Length > 0)
                {
                    foreach (FileInfo file in dInfo.GetFiles())
                    {
                        file.Delete();
                    }
                }
            }
            catch (Exception ex)
            {
                res.ResponseType = DocResponseType.Error;
                res.Message = ex.Message;
            }
            return res;
        }
        private static byte[] CompressImage(Image original)
        {
            byte[] retBytes = null;

            ImageCodecInfo jpgEncoder = null;
            ImageCodecInfo[] codecs = ImageCodecInfo.GetImageEncoders();

            foreach (ImageCodecInfo codec in codecs)
            {
                if (codec.FormatID == ImageFormat.Jpeg.Guid)
                {
                    jpgEncoder = codec;
                    break;
                }
            }

            if (jpgEncoder != null)
            {
                System.Drawing.Imaging.Encoder encoder = System.Drawing.Imaging.Encoder.Quality;
                EncoderParameters encoderParameters = new EncoderParameters(1);

                EncoderParameter encoderParameter = new EncoderParameter(encoder, 500L);
                encoderParameters.Param[0] = encoderParameter;

                using (Bitmap bmpImg = new Bitmap(original))
                {
                    MemoryStream ms = new MemoryStream();
                    bmpImg.Save(ms, jpgEncoder, encoderParameters);

                    ms.Position = 0;
                    retBytes = ms.ToArray();
                    ms.Close();
                    ms.Dispose();
                }

            }

            return retBytes;
        }
    }
}
