using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.MailQueue;
using TCMPLApp.WebApi.Classes;
using TCMPLApp.WebApi.Models;

namespace TCMPLApp.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class EmailController : BaseController<EmailController>
    {
        private readonly IMailQueueMailsAdd _mailQueueMailsAdd;
        private readonly IConfiguration _configuration;
        public EmailController(IMailQueueMailsAdd mailQueueMailsAdd, IConfiguration configuration)
        {
            _mailQueueMailsAdd = mailQueueMailsAdd;
            _configuration = configuration;
        }

        [HttpPost]
        [Route("SendEmailAddToQueue")]

        public async Task<ActionResult> SendEmailAddToQueue(
            string MailTo, string MailCC , string MailBCC,
            string MailSubject, string MailBody1, string MailBody2, 
            string MailFrom,string MailFormatType, 
            List<IFormFile> MailAttachments
            )
        {

            string attachmentOSName = String.Empty;
            string attachmentBusinessName = String.Empty;

            if (MailAttachments?.Count > 0)
            {
                foreach (var formFile in MailAttachments)
                {
                    if (formFile.Length > 0)
                    {
                        string osFileName = await StorageHelper.SaveFileAsync(StorageHelper.TCMPLAppMailAttachmentPickUpRepository, "", "", formFile, _configuration);
                        attachmentOSName = osFileName + ";";
                        attachmentBusinessName = formFile.FileName + ";";
                    }
                }
            }

            var data = await _mailQueueMailsAdd.EmailAddToQueueAsync(
                BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PMailTo = MailTo,
                    PMailBcc = MailBCC,
                    PMailCc = MailCC,
                    PMailSubject = MailSubject,
                    PMailBody1 = MailBody1,
                    PMailBody2 = MailBody2,
                    PMailFrom = MailFrom,
                    PMailType = MailFormatType,
                    PMailAttachmentsBusinessNm = attachmentBusinessName,
                    PMailAttachmentsOsNm = attachmentOSName
                }
            );

            return Ok(data );
        }



        [HttpPost]
        [Route("SendEmailAddToHoldQueue")]
        public async Task<ActionResult> SendEmailAddToHoldQueue(
            string MailTo, string MailCC, string MailBCC,
            string MailSubject, string MailBody1, string MailBody2,
            string MailFrom, string MailFormatType,
            List<IFormFile> MailAttachments
            )
        {

            string attachmentOSName = String.Empty;
            string attachmentBusinessName = String.Empty;

            if (MailAttachments?.Count > 0)
            {
                foreach (var formFile in MailAttachments)
                {
                    if (formFile.Length > 0)
                    {
                        string osFileName = await StorageHelper.SaveFileAsync(StorageHelper.TCMPLAppMailAttachmentPickUpRepository, "", "", formFile, _configuration);
                        attachmentOSName = osFileName + ";";
                        attachmentBusinessName = formFile.FileName + ";";
                    }
                }
            }

            var data = await _mailQueueMailsAdd.EmailAddToHoldAsync(
                BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PMailTo = MailTo,
                    PMailBcc = MailBCC,
                    PMailCc = MailCC,
                    PMailSubject = MailSubject,
                    PMailBody1 = MailBody1,
                    PMailBody2 = MailBody2,
                    PMailFrom = MailFrom,
                    PMailType = MailFormatType,
                    PMailAttachmentsBusinessNm = attachmentBusinessName,
                    PMailAttachmentsOsNm = attachmentOSName
                }
            );

            return Ok(data);
        }


        [HttpPost]
        [Route("SendEmailAddToQueueWithAttachments")]

        public async Task<ActionResult> SendEmailAddToQueueWithAttachments(
            [FromBody] HCModel hcModel
            )
        {



            string attachmentOSName = String.Empty;
            string attachmentBusinessName = String.Empty;
            string osFileName = string.Empty;
            if (hcModel.Files?.Count > 0)
            {
                foreach (var formFile in hcModel.Files)
                {
                    if (formFile.Length > 0)
                    {
                        osFileName = await StorageHelper.SaveFileAsync(StorageHelper.TCMPLAppMailAttachmentPickUpRepository, "", "", formFile, _configuration);
                        attachmentOSName += osFileName + ";";
                        attachmentBusinessName += formFile.FileName + ";";
                    }
                }
            }

            var data = await _mailQueueMailsAdd.EmailAddToQueueAsync(
                BaseSpTcmPLGet(), new ParameterSpTcmPL
                {
                    PMailTo = hcModel.MailTo,
                    PMailBcc = hcModel.MailCc,
                    PMailCc = hcModel.MailBcc,
                    PMailSubject = hcModel.MailSubject,
                    PMailBody1 = hcModel.MailBody1,
                    PMailBody2 = hcModel.MailBody2,
                    PMailFrom = hcModel.MailFrom,
                    PMailType = hcModel.MailFormatType,
                    PMailAttachmentsBusinessNm = attachmentBusinessName,
                    PMailAttachmentsOsNm = attachmentOSName
                }
            );

            return Ok(data);
        }



    }
}
