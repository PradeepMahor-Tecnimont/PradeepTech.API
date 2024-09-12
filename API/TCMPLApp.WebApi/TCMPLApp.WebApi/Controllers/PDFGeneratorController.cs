using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApi.Classes;
using TCMPLApp.WebApi.Models;
//using PuppeteerSharp;
using System.Net;
using System.Text;
using System.IO;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using TCMPLApp.WebApi.Repositories;
using System.Data;

namespace TCMPLApp.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class PDFGeneratorController : BaseController<PDFGeneratorController>
    {
        private readonly IConfiguration _configuration;
        private readonly IPDFGenerator _pdfGenerator;

        public PDFGeneratorController(IConfiguration configuration,
            IPDFGenerator pdfGenerator
            )
        {
            _configuration = configuration;
            _pdfGenerator = pdfGenerator;
        }

        //[Route("ConvertHtmlToPdf")]
        //[HttpPost]
        //public async Task<ActionResult> ConvertHtmlToPdf([FromBody] object jsonParams)
        //{
        //    var jsonObject = JObject.Parse(jsonParams.ToString());
        //    string htmlcontent = jsonObject["Htmlcontent"].ToString();
        //    string fname = jsonObject["Fname"].ToString();

        //    byte[] m_Bytes = null;
        //    string pdfType = _configuration.GetSection("ContentTypePDF").Value.ToString();
        //    string pdfGeneratorRepository = _configuration.GetSection("TCMPLPdfGeneratorRepository").Value.ToString();
        //    var filePath = Path.Combine(pdfGeneratorRepository, "PdfFiles");
        //    var filePathSource = Path.Combine(pdfGeneratorRepository, "SourceHtmlContent");

        //    var fileName = Guid.NewGuid();
        //    var fileNameHtml = fileName + ".html";
        //    var fileNamePdf = fileName + ".pdf";

        //    string downloadPdfFileName = Path.Combine(filePath, fileNamePdf);

        //    if (!Directory.Exists(filePath))
        //        Directory.CreateDirectory(filePath);

        //    if (!Directory.Exists(filePathSource))
        //        Directory.CreateDirectory(filePathSource);

        //    var browserFetcher = new BrowserFetcher(new BrowserFetcherOptions
        //    {
        //        Path = pdfGeneratorRepository //"C:\\TCMPLPdfGenerator" 
        //    });

        //    var revision = await browserFetcher.DownloadAsync(BrowserFetcher.DefaultChromiumRevision);
        //    var browser = await Puppeteer.LaunchAsync(new LaunchOptions
        //    {
        //        Headless = true,
        //        ExecutablePath = revision.ExecutablePath
        //    });

        //    try
        //    {
        //        using (var page = await browser.NewPageAsync())
        //        {
        //            try
        //            {
        //                //string pathToHTMLFile = "C:\\TCMPLPdfGeneratorRepository\\SourceHtmlContent\\Sample.html";
        //                //string htmlString = System.IO.File.ReadAllText(pathToHTMLFile);
        //                //byte[] byteText = Encoding.ASCII.GetBytes(htmlString);

        //                byte[] byteText = Encoding.ASCII.GetBytes(htmlcontent);

        //                var cancellationTokenSource = new CancellationTokenSource();
        //                var cancellationToken = cancellationTokenSource.Token;

        //                System.IO.File.WriteAllBytes(Path.Combine(pdfGeneratorRepository, "SourceHtmlContent", fileNameHtml), byteText.ToArray());

        //                await Task.Delay(1000);

        //                WaitUntilNavigation[] waitUntil = new[] { WaitUntilNavigation.Networkidle0, WaitUntilNavigation.Networkidle2, WaitUntilNavigation.DOMContentLoaded, WaitUntilNavigation.Load };
        //                await page.GoToAsync(Path.Combine(pdfGeneratorRepository, "SourceHtmlContent", fileNameHtml), new PuppeteerSharp.NavigationOptions { WaitUntil = waitUntil });

        //                await page.PdfAsync(downloadPdfFileName);
        //            }
        //            catch (Exception)
        //            {
        //                throw;
        //            }
        //            finally
        //            {
        //                if (!page.IsClosed && page != null)
        //                {
        //                    await page.CloseAsync();
        //                }
        //            }
        //        }

        //        await Task.Delay(1000);

        //        using (var fs = new FileStream(Path.Combine(pdfGeneratorRepository, "PdfFiles", downloadPdfFileName), FileMode.Open, FileAccess.Read))
        //        {
        //            BinaryReader br = new BinaryReader(fs);
        //            long numBytes = new FileInfo(Path.Combine(pdfGeneratorRepository, "PdfFiles", downloadPdfFileName)).Length;
        //            m_Bytes = br.ReadBytes((int)numBytes).ToArray();
        //            fs.Dispose();
        //        }

        //        if (System.IO.File.Exists(Path.Combine(pdfGeneratorRepository, "SourceHtmlContent", fileNameHtml)))
        //            System.IO.File.Delete(Path.Combine(pdfGeneratorRepository, "SourceHtmlContent", fileNameHtml));

        //        if (System.IO.File.Exists(Path.Combine(pdfGeneratorRepository, "PdfFiles", downloadPdfFileName)))
        //            System.IO.File.Delete(Path.Combine(pdfGeneratorRepository, "PdfFiles", downloadPdfFileName));

        //        var t = Task.Run(() =>
        //        {
        //            return this.File(fileContents: m_Bytes, contentType: pdfType, fileDownloadName: fname);
        //        });

        //        return await t;
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        await browser.CloseAsync();
        //    }
        //}


        [Route("ConvertHtmlToPdf")]
        [HttpPost]
        public async Task<ActionResult> ConvertHtmlToPdf([FromBody] object jsonParams)
        {
            var jsonObject = JObject.Parse(jsonParams.ToString());
            string htmlcontent = jsonObject["Htmlcontent"].ToString();
            string fname = jsonObject["Fname"].ToString();
            string pdfType = _configuration.GetSection("ContentTypePDF").Value.ToString();

            var m_bytes = await _pdfGenerator.GeneratePDF(htmlcontent);

            return this.File(fileContents: m_bytes, contentType: pdfType, fileDownloadName: fname);
        }
    }
}
