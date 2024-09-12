using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System.Net;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.DataAccess.Repositories.MailQueue;
using TCMPLApp.WebApi.Classes;
using TCMPLApp.WebApi.Models;
using TCMPLApp.WebApi.Repositories;

namespace TCMPLApp.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class EmpGenInfoDetailsController : BaseController<EmpGenInfoDetailsController>
    {
        private readonly IConfiguration _configuration;
        private readonly IPDFGenerator _pdfGenerator;
        private readonly ICommonEmployeeDetailsRepository _commonEmployeeDetailsRepository;
        private readonly ILoAAddendumConsentDetailsRepository _loaAddendumConsentDetails;
        private readonly IDeemedEmpLoaAcceptanceRepository _deemedEmpLoaAcceptanceRepository;

        private readonly ILoAAddendumConsentUpdateRepository _loaAddendumConsentUpdateRepository;
        private readonly IMailQueueMailsAdd _mailQueueMailsAdd;


        public EmpGenInfoDetailsController(IConfiguration configuration, IPDFGenerator pdfGenerator,
            IMailQueueMailsAdd mailQueueMailsAdd,
            ICommonEmployeeDetailsRepository commonEmployeeDetailsRepository,
            ILoAAddendumConsentDetailsRepository loaAddendumConsentDetailsRepository,
            IDeemedEmpLoaAcceptanceRepository deemedEmpLoaAcceptanceRepository,
            ILoAAddendumConsentUpdateRepository loaAddendumConsentUpdateRepository
            )
        {
            _configuration = configuration;
            _pdfGenerator = pdfGenerator;
            _mailQueueMailsAdd = mailQueueMailsAdd;
            _commonEmployeeDetailsRepository = commonEmployeeDetailsRepository;
            _loaAddendumConsentDetails = loaAddendumConsentDetailsRepository;
            _deemedEmpLoaAcceptanceRepository = deemedEmpLoaAcceptanceRepository;
            _loaAddendumConsentUpdateRepository = loaAddendumConsentUpdateRepository;
        }

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

        [Route("LoaAddendumGeneratePDFSendMail")]
        [HttpPost]
        public async Task<ActionResult> LoaAddendumGeneratePDFSendMail(HCModel hcModel)
        {
            try
            {
                string tempFileName = ApiHelper.generateText(8);
                string strFileOSName = String.Format("LoaAddendumAcceptance_{0}_{1}_{2}.{3}", hcModel.Empno, DateTime.Now.ToString("yyyyMMdd_HHmm"), tempFileName, "pdf");

                string strFileDispName = String.Format("LoaAddendumAcceptance_{0}_{1}.{2}", hcModel.Empno, DateTime.Now.ToString("yyyyMMdd_HHmm"), "pdf");

                var m_bytes = await _pdfGenerator.GeneratePDF(hcModel.Htmlcontent);

                string emailPickupDir = _configuration.GetSection(StorageHelper.TCMPLAppMailAttachmentPickUpRepository).Value.ToString();

                string pdfFilePath = Path.Combine(emailPickupDir, strFileOSName);

                System.IO.File.WriteAllBytes(pdfFilePath, m_bytes);

                var pdfGenerationEventUpdated = await _loaAddendumConsentUpdateRepository.PDFGeneratedEventUpdateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL { PEmpno = hcModel.Empno, PFileName = strFileOSName }
                    );
                if (pdfGenerationEventUpdated.PMessageType == NotOk)
                {
                    throw new Exception("PDF generation update failed-" + pdfGenerationEventUpdated.PMessageText);
                }

                var data = await _mailQueueMailsAdd.EmailAddToQueueAsync(
                 BaseSpTcmPLGet(), new ParameterSpTcmPL
                 {
                     PMailTo = hcModel.MailTo,
                     PMailType = "HTML",
                     PMailBody1 = hcModel.MailBody1,
                     PMailSubject = hcModel.MailSubject,
                     PMailAttachmentsBusinessNm = strFileDispName,
                     PMailAttachmentsOsNm = strFileOSName
                 }
                 );
                if (data.PMessageType == NotOk)
                {
                    throw new Exception("PDF generated successfully, Email queue updation failed-" + data.PMessageText);
                }

                var emailQueuedEventUpdated = await _loaAddendumConsentUpdateRepository.EmailQueuedEventUpdateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL { PEmpno = hcModel.Empno }
                        );
                if (emailQueuedEventUpdated.PMessageType == NotOk)
                {
                    throw new Exception(emailQueuedEventUpdated.PMessageText);
                }
                return Ok("Pdf generated & email queued successfully.");
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message + " - for Empno " + hcModel.Empno, ex);
            }
        }

        [Route("SetLoaDeemedAcceptance")]
        [HttpGet]
        public async Task<ActionResult> SetLoaDeemedAcceptance()
        {
            var deemedEmpLoaAcceptance = await _deemedEmpLoaAcceptanceRepository.GetDeemedEmpLoaAcceptanceAsync(
                  BaseSpTcmPLGet(), new ParameterSpTcmPL());

            if (!deemedEmpLoaAcceptance.PEmpList.Any())
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, "No data found");
            }
            return Ok(deemedEmpLoaAcceptance.PEmpList);

        }
    }
}