using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Validation;
using DocumentFormat.OpenXml.Wordprocessing;
using HtmlToOpenXml;
using System.Text;

namespace TCMPLApp.WebApi.Repositories
{
    public class HtmlToOpenXmlDoc : IHtmlToOpenXmlDoc
    {
        ILogger<HtmlToOpenXmlDoc> _logger;
        IConfiguration _configuration;

        public HtmlToOpenXmlDoc(ILogger<HtmlToOpenXmlDoc> logger, IConfiguration configuration) 
        { 
            _logger = logger;
            _configuration = configuration;
        }

        public static void CopyStream(Stream source, Stream target)
        {
            if (source != null)
            {
                MemoryStream mstream = source as MemoryStream;
                if (mstream != null) mstream.WriteTo(target);
                else
                {
                    byte[] buffer = new byte[2048];
                    int length = buffer.Length, size;

                    while ((size = source.Read(buffer, 0, length)) != 0)
                        target.Write(buffer, 0, size);
                }
            }
        }

        public async Task<byte[]> GenerateOpenXmlDoc(string HtmlContent)
        {
            byte[] m_Bytes = null;
            string openXmlGeneratorRepository = _configuration.GetSection("TCMPLPdfGeneratorRepository").Value.ToString();
            var filePath = Path.Combine(openXmlGeneratorRepository, "PdfFiles");
            var templatePath = Path.Combine(openXmlGeneratorRepository, "HtmlTemplate");

            var fileName = Guid.NewGuid();
            var fileNameOpenXml = Path.Combine(filePath, fileName + ".docx");

            if (!Directory.Exists(filePath))
                Directory.CreateDirectory(filePath);

            try
            {
                using (MemoryStream generatedDocument = new MemoryStream())
                {                    
                    using (var buffer = File.Open(Path.Combine(templatePath, "DigiformTemplate.docx"), FileMode.Open))
                    {
                        buffer.CopyTo(generatedDocument);
                    }

                    generatedDocument.Position = 0L;

                    using (WordprocessingDocument package = WordprocessingDocument.Open(generatedDocument, true))                    
                    {
                        MainDocumentPart mainPart = package.MainDocumentPart;
                        if (mainPart == null)
                        {
                            mainPart = package.AddMainDocumentPart();
                            new Document(new Body()).Save(mainPart);
                        }

                        HtmlConverter converter = new HtmlConverter(mainPart);
                        Body body = mainPart.Document.Body;

                        converter.ParseHtml(HtmlContent);
                        mainPart.Document.Save();

                        AssertThatOpenXmlDocumentIsValid(package);
                    }

                    m_Bytes = generatedDocument.ToArray();

                    await Task.Delay(1000);

                    return m_Bytes;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error while generating Doc.", ex);
            }
        }

        public async Task<byte[]> GenerateOpenXmlToWord(string HtmlContent)
        {
            byte[] m_Bytes = null;
            string openXmlGeneratorRepository = _configuration.GetSection("TCMPLPdfGeneratorRepository").Value.ToString();
            var filePath = Path.Combine(openXmlGeneratorRepository, "PdfFiles");
            var templatePath = Path.Combine(openXmlGeneratorRepository, "HtmlTemplate");

            var fileName = Guid.NewGuid();
            var fileNameOpenXml = Path.Combine(filePath, fileName + ".docx");

            if (!Directory.Exists(filePath))
                Directory.CreateDirectory(filePath);

            try
            {
                using (MemoryStream generatedDocument = new MemoryStream())
                {
                    using (var buffer = File.Open(Path.Combine(templatePath, "DigiformTemplate.docx"), FileMode.Open))
                    {
                        buffer.CopyTo(generatedDocument);
                    }

                    generatedDocument.Position = 0L;

                    //using (WordprocessingDocument package = WordprocessingDocument.Open(generatedDocument, true))
                    //{
                    //    MainDocumentPart mainPart = package.MainDocumentPart;
                    //    if (mainPart == null)
                    //    {
                    //        mainPart = package.AddMainDocumentPart();
                    //        new Document(new Body()).Save(mainPart);
                    //    }

                    //    HtmlConverter converter = new HtmlConverter(mainPart);
                    //    Body body = mainPart.Document.Body;

                    //    converter.ParseHtml(HtmlContent);
                    //    mainPart.Document.Save();

                    //    AssertThatOpenXmlDocumentIsValid(package);
                    //}

                    m_Bytes =  generatedDocument.ToArray();

                    await Task.Delay(1000);

                    return m_Bytes;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error while generating Doc.", ex);
            }
        }

        public void AssertThatOpenXmlDocumentIsValid(WordprocessingDocument wpDoc)
        {
            var validator = new OpenXmlValidator(FileFormatVersions.Office2021);
            var errors = validator.Validate(wpDoc);

            if (!errors.GetEnumerator().MoveNext())
                return;
        }
    }
}
