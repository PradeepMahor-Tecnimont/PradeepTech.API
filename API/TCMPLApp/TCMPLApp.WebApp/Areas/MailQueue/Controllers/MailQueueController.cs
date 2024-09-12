using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.DataAccess.Repositories.MailQueue;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.WebApp.Areas.MailQueue.Controllers
{
    [Authorize]
    [Area("MailQueue")]
    public class MailQueueController : BaseController
    {
        private readonly IMailQueueMailsRepository _mailQueueMailsRepository;

        public MailQueueController(IMailQueueMailsRepository mailQueueMailsRepository)
        {
            _mailQueueMailsRepository = mailQueueMailsRepository;
        }
        public IActionResult Index()
        {
            return View();
        }

        public async Task<JsonResult> GetMailQueuePendingMails()
        {
            var data = await _mailQueueMailsRepository.MailQueuePendingMailsAsync(
            BaseSpTcmPLGet(),
            new ParameterSpTcmPL
            {
                PRowNumber = 0,
                PPageLength = 100
            });

            return Json(data);

        }
    }
}
