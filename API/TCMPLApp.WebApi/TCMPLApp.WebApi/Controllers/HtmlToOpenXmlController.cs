using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApi.Classes;
using Newtonsoft.Json.Linq;
using TCMPLApp.WebApi.Repositories;
using System.Text;

namespace TCMPLApp.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class HtmlToOpenXmlController : BaseController<HtmlToOpenXmlController>
    {
        private readonly IConfiguration _configuration;
        private readonly IHtmlToOpenXmlDoc _htmlToOpenXmlDoc;

        public HtmlToOpenXmlController(IConfiguration configuration,
            IHtmlToOpenXmlDoc htmlToOpenXmlDoc
            )
        {
            _configuration = configuration;
            _htmlToOpenXmlDoc = htmlToOpenXmlDoc;
        }

        [Route("ConvertHtmlToOpenXml")]
        [HttpPost]
        public async Task<ActionResult> ConvertHtmlToOpenXml([FromBody] object jsonParams)
        {
            var jsonObject = JObject.Parse(jsonParams.ToString());
            string htmlcontent = jsonObject["Htmlcontent"].ToString();
            string fname = jsonObject["Fname"].ToString();

            string xmlType = _configuration.GetSection("ContentTypeOpenXMLDoc").Value.ToString();

            var m_bytes = await _htmlToOpenXmlDoc.GenerateOpenXmlDoc(htmlcontent);

            return this.File(fileContents: m_bytes, contentType: xmlType, fileDownloadName: fname);
        }

        [Route("ConvertHtmlToword")]
        [HttpPost]
        public ActionResult ConvertHtmlToWord([FromBody] object jsonParams)
        {
            var jsonObject = JObject.Parse(jsonParams.ToString());
            string htmlcontent = jsonObject["Htmlcontent"].ToString();
            string fname = jsonObject["Fname"].ToString();

            string docType = _configuration.GetSection("ContentTypeOpenXMLDoc").Value.ToString();

            var m_bytes = Encoding.ASCII.GetBytes(htmlcontent);

            return this.File(fileContents: m_bytes, contentType: docType, fileDownloadName: fname);
        }

    }
}
