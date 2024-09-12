using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualBasic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.HSE;
using TCMPLApp.Domain.Models.HSE;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Areas.HSE.Controllers
{
    [Area("HSE")]
    public class HomeController : BaseController
    {
        private readonly IHSEQuizCounterDetailsRepository _hSEQuizCounterDetailsRepository;
        private readonly IHSEQuizDetailsRepository _hSEQuizDetailsRepository;

        public HomeController(IHSEQuizCounterDetailsRepository hSEQuizCounterDetailsRepository, IHSEQuizDetailsRepository hSEQuizDetailsRepository)
        {
            _hSEQuizCounterDetailsRepository = hSEQuizCounterDetailsRepository;
            _hSEQuizDetailsRepository = hSEQuizDetailsRepository;
        }

        public async Task<IActionResult> Index()
        {
            string strEmpCount = "0";
            string strDescription = "Quiz";
            string strActiveQuiz = "0";

            HSEQuizDetailOut details = await _hSEQuizDetailsRepository.HSEQuizDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL());

            if(details.PMessageType == "OK")
            {
                HSEQuizCountDetailsOut result = await _hSEQuizCounterDetailsRepository.HSEQuizCounterDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL
                           {
                               PQuizId = details.PQuizId
                           });

                strEmpCount = result.PEmpSubmitCount?.ToString();
                strDescription = details.PDescription;
                strActiveQuiz = "1";
            }

            ViewData["EmployeeCount"] = strEmpCount;
            ViewData["QuizTitle"] = strDescription;
            ViewData["ActiveQuiz"] = strActiveQuiz;

            return View();
        }
        public IActionResult IncidentIndex()
        {
            return View();
        }
    }
}
