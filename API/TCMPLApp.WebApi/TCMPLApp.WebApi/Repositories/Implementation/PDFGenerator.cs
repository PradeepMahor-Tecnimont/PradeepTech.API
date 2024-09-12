using Newtonsoft.Json.Linq;
//using PuppeteerSharp;
using System.Text;

namespace TCMPLApp.WebApi.Repositories
{
    public class PDFGenerator : IPDFGenerator
    {
        ILogger<PDFGenerator> _logger;
        IConfiguration _configuration;

        public PDFGenerator(ILogger<PDFGenerator> logger, IConfiguration configuration) 
        { 
            _logger = logger;
            _configuration = configuration;
        }

        public Task<byte[]> GeneratePDF(string HtmlContent)
        {

            throw new Exception("TCMPL Generate PDF has been DisContinued.");

            //byte[] m_Bytes = null;


            //string pdfGeneratorRepository = _configuration.GetSection("TCMPLPdfGeneratorRepository").Value.ToString();
            //var filePath = Path.Combine(pdfGeneratorRepository, "PdfFiles");
            //var filePathSource = Path.Combine(pdfGeneratorRepository, "SourceHtmlContent");

            //var fileName = Guid.NewGuid();
            //var fileNameHtml = fileName + ".html";
            //var fileNamePdf = fileName + ".pdf";

            //string downloadPdfFileName = Path.Combine(filePath, fileNamePdf);

            //if (!Directory.Exists(filePath))
            //    Directory.CreateDirectory(filePath);

            //if (!Directory.Exists(filePathSource))
            //    Directory.CreateDirectory(filePathSource);

            //var browserFetcher = new BrowserFetcher(new BrowserFetcherOptions
            //{
            //    Path = pdfGeneratorRepository //"C:\\TCMPLPdfGenerator" 
            //});

            //var revision = await browserFetcher.DownloadAsync(BrowserFetcher.DefaultChromiumRevision);
            //var browser = await Puppeteer.LaunchAsync(new LaunchOptions
            //{
            //    Headless = true,
            //    ExecutablePath = revision.ExecutablePath
            //});

            //try
            //{
            //    using (var page = await browser.NewPageAsync())
            //    {
            //        try
            //        {

            //            byte[] byteText = Encoding.ASCII.GetBytes(HtmlContent);

            //            var cancellationTokenSource = new CancellationTokenSource();
            //            var cancellationToken = cancellationTokenSource.Token;

            //            System.IO.File.WriteAllBytes(Path.Combine(pdfGeneratorRepository, "SourceHtmlContent", fileNameHtml), byteText.ToArray());

            //            await Task.Delay(1000);

            //            WaitUntilNavigation[] waitUntil = new[] { WaitUntilNavigation.Networkidle0, WaitUntilNavigation.Networkidle2, WaitUntilNavigation.DOMContentLoaded, WaitUntilNavigation.Load };
            //            await page.GoToAsync(Path.Combine(pdfGeneratorRepository, "SourceHtmlContent", fileNameHtml), new PuppeteerSharp.NavigationOptions { WaitUntil = waitUntil });

            //            await page.PdfAsync(downloadPdfFileName);
            //        }
            //        catch (Exception)
            //        {
            //            throw;
            //        }
            //        finally
            //        {
            //            if (!page.IsClosed && page != null)
            //            {
            //                await page.CloseAsync();
            //            }
            //        }
            //    }

            //    await Task.Delay(1000);

            //    using (var fs = new FileStream(Path.Combine(pdfGeneratorRepository, "PdfFiles", downloadPdfFileName), FileMode.Open, FileAccess.Read))
            //    {
            //        BinaryReader br = new BinaryReader(fs);
            //        long numBytes = new FileInfo(Path.Combine(pdfGeneratorRepository, "PdfFiles", downloadPdfFileName)).Length;
            //        m_Bytes = br.ReadBytes((int)numBytes).ToArray();
            //        fs.Dispose();
            //    }

            //    if (System.IO.File.Exists(Path.Combine(pdfGeneratorRepository, "SourceHtmlContent", fileNameHtml)))
            //        System.IO.File.Delete(Path.Combine(pdfGeneratorRepository, "SourceHtmlContent", fileNameHtml));

            //    if (System.IO.File.Exists(Path.Combine(pdfGeneratorRepository, "PdfFiles", downloadPdfFileName)))
            //        System.IO.File.Delete(Path.Combine(pdfGeneratorRepository, "PdfFiles", downloadPdfFileName));
            //    return m_Bytes;
            //}
            //catch (Exception ex)
            //{
            //    throw new Exception("Error while generating PDF.", ex);
            //}
            //finally
            //{
            //    await browser.CloseAsync();
            //}
        }
    }
}
