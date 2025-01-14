using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Drawing.Imaging;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace NexelusApp.Service.Utilities
{
    public class Utility
    {
        public static string GetExpenseTransactionImage(string documentPath, int company_code, string record_id, string transaction_id)
        {
            string retVal = "";

            try
            {
                
                string sPath = documentPath + "\\" + company_code.ToString() + "\\" + record_id + "\\" + transaction_id + "\\";

                DirectoryInfo dInfo = new DirectoryInfo(sPath);

                if (dInfo.Exists)
                {
                    if (dInfo.GetFiles().Length > 0)
                    {
                        if (dInfo.GetFiles()[0].Extension.ToLower() != ".jpg" && dInfo.GetFiles()[0].Extension.ToLower() != ".png"
                            && dInfo.GetFiles()[0].Extension.ToLower() != ".gif" && dInfo.GetFiles()[0].Extension.ToLower() != ".jpeg" 
                            && dInfo.GetFiles()[0].Extension != ".bmp")
                        {
                            throw new Exception("The file type is not supported");
                        }

                        string filePath = dInfo.GetFiles()[0].FullName;

                        //FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.Read);
                        using (Image origImage = Image.FromFile(filePath))
                        {

                            //Image resizedImage = origImage;

                            //if (origImage.Size.Width > 50)
                            //{
                            //    resizedImage = ScaleImage(origImage, 50, origImage.Size.Height);
                            //}
                            //else if (origImage.Size.Height > 50)
                            //{
                            //    resizedImage = ScaleImage(origImage, origImage.Size.Width, 50);
                            //}

                            retVal = Convert.ToBase64String(CompressImage(origImage));

                            origImage.Dispose();
                        }
                        //resizedImage.Dispose();
                        //retVal = Convert.ToBase64String(imageToByteArray(resizedImage));

                    }
                }

            }
            catch (Exception )
            {
                throw;
            }

            return retVal;
        }

        public static string GetExpenseReportAttachment(string documentPath, int company_code, string record_id, out string file_url)
        {
            string retVal = "";
            file_url = "";
            try
            {

                string sPath = documentPath + "\\" + company_code.ToString() + "\\" + record_id + "\\";

                DirectoryInfo dInfo = new DirectoryInfo(sPath);

                if (dInfo.Exists)
                {
                    if (dInfo.GetFiles().Length > 0)
                    {
                        if (dInfo.GetFiles()[0].Extension.ToLower() != ".jpg" && dInfo.GetFiles()[0].Extension.ToLower() != ".png"
                            && dInfo.GetFiles()[0].Extension.ToLower() != ".gif" && dInfo.GetFiles()[0].Extension.ToLower() != ".jpeg"
                            && dInfo.GetFiles()[0].Extension != ".bmp")
                        {
                            file_url = dInfo.GetFiles()[0].FullName;
                            retVal = "Not an image file";
                        }else {
                            file_url = "";
                            string filePath = dInfo.GetFiles()[0].FullName;
                            using (Image origImage = Image.FromFile(filePath))
                            {
                                retVal = Convert.ToBase64String(CompressImage(origImage));
                                origImage.Dispose();
                            }
                        }
                    }
                }

            }
            catch (Exception)
            {
                throw;
            }

            return retVal;
        }

        public static bool SetExpenseTransactionImage(string documentPath, int company_code, string record_id, string transaction_id, string imageData)
        {
            bool retVal = false;

            try
            {
                string sPath = documentPath + "\\" + company_code.ToString() + "\\" + record_id + "\\" + transaction_id + "\\";

                if (!Directory.Exists(sPath))
                {
                    Directory.CreateDirectory(sPath);                    
                }

                DirectoryInfo dInfo = new DirectoryInfo(sPath);

                if (dInfo.GetFiles().Length > 0)
                {
                    // First delete the existing file and then create a new file.
                    foreach (FileInfo fileToDel in dInfo.GetFiles())
                    {
                        fileToDel.Delete();
                    }

                    sPath += DateTime.Now.ToString("s").Replace("T", "").Replace(":", "") + ".jpg";
                }
                else
                {
                    sPath += DateTime.Now.ToString("s").Replace("T", "").Replace(":", "") + ".jpg";
                }

                File.WriteAllBytes(sPath, Convert.FromBase64String(imageData));
                retVal = true;
            }
            catch (Exception)
            {
                throw;
            }

            return retVal;
        }

        public static bool DeleteExpenseTransactionImage(string documentPath, int company_code, string record_id, string transaction_id) 
        {
            bool retVal = false;

            try
            {
                string sPath = documentPath + "\\" + company_code.ToString() + "\\" + record_id + "\\" + transaction_id + "\\";

                if (!Directory.Exists(sPath))
                {
                    //No image exists
                    return true;
                }

                DirectoryInfo dInfo = new DirectoryInfo(sPath);

                if (dInfo.GetFiles().Length > 0)
                {
                    foreach (FileInfo file in dInfo.GetFiles())
                    {                       
                        file.Delete();                        
                    }
                }                
                
                retVal = true;
            }
            catch (Exception)
            {
                throw;
            }

            return retVal;
        }

        public static bool DoesImageExists(string documentPath, int company_code, string record_id, string transaction_id)
        {
            bool retVal = false;

            try
            {
                string sPath = documentPath + "\\" + company_code.ToString() + "\\" + record_id + "\\" + transaction_id + "\\";

                if (Directory.Exists(sPath))
                {
                    DirectoryInfo dInfo = new DirectoryInfo(sPath);

                    if (dInfo.GetFiles().Length > 0)
                    {
                        retVal = true;
                    }
                }
                
            }
            catch (Exception)
            {
                throw;
            }

            return retVal;
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

        private static Image ScaleImage(Image image, int maxWidth, int maxHeight)
        {
            var ratioX = (double)maxWidth / image.Width;
            var ratioY = (double)maxHeight / image.Height;
            var ratio = Math.Min(ratioX, ratioY);

            var newWidth = (int)(image.Width * ratio);
            var newHeight = (int)(image.Height * ratio);

            var newImage = new Bitmap(newWidth, newHeight);

            using (var graphics = Graphics.FromImage(newImage))
            {
                //graphics.SmoothingMode = SmoothingMode.HighQuality;
                //graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                //graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;
                //graphics.DrawImage(image, 0, 0, newWidth, newHeight);

                graphics.Clear(Color.Transparent);

                // This is said to give best quality when resizing images
                graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;

                graphics.DrawImage(image,
                    new Rectangle(0, 0, newWidth, newHeight),
                    new Rectangle(0, 0, image.Width, image.Height),
                    GraphicsUnit.Pixel);
            }

            return newImage;
        }

        private static byte[] imageToByteArray(System.Drawing.Image imageIn)
        {
            MemoryStream ms = new MemoryStream();
            imageIn.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
            return ms.ToArray();
        }

        private static Image byteArrayToImage(byte[] byteArrayIn)
        {
            MemoryStream ms = new MemoryStream(byteArrayIn);
            Image returnImage = Image.FromStream(ms);
            return returnImage;
        }

    }
}
