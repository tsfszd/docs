using System;
using System.Collections.Generic;
using System.IO;
using iText.IO.Font;
using iText.IO.Font.Constants;
using iText.Kernel.Font;
using iText.Kernel.Pdf;
using iText.Kernel.Pdf.Canvas;
using iText.Layout;
using iText.Layout.Element;

namespace PDFEdit
{
    class Program
    {
        static void Main(string[] args)
        {
            string src = "C:\\testpdf\\Facebook_23938336.pdf";
            string dest = "C:\\testpdf\\test_dest.pdf";

            PdfDocument pdfDoc = new PdfDocument(new PdfReader(src), new PdfWriter(dest));

            PdfCanvas canvas = new PdfCanvas(pdfDoc.GetFirstPage());

            //set text
            IList<String> text = new List<String>();
            text.Add("Approved By: " + "Tao Lin");
            text.Add("Approved Date: " + "2021-09-07");

            canvas.BeginText()
                .SetFontAndSize(PdfFontFactory.CreateFont(FontConstants.HELVETICA_BOLD), 14) //set font
                .SetLeading(14* 1.2f) //Set the space between the text
                .MoveText(300, 750); //set location of the approval text box

            //List text
            foreach(string s in text)
            {
                canvas.NewlineShowText(s);
            }
            canvas.EndText();


            pdfDoc.Close();
        }
    }
}
