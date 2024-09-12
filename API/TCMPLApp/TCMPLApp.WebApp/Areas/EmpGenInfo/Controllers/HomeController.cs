using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.Domain.Models;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using TCMPLApp.DataAccess.Models;
namespace TCMPLApp.WebApp.Areas.EmpGenInfo.Controllers
{
    [Area("EmpGenInfo")]
    public class HomeController : BaseController
    {
        private readonly ILoaAddendumAcceptanceDetailsRepository _loaAddendumAcceptanceDetailsRepository;
        private readonly IEmpRelativesAsColleaguesDetailsRepository _empRelativesAsColleaguesDetailsRepository;

        public HomeController(ILoaAddendumAcceptanceDetailsRepository loaAddendumAcceptanceDetailsRepository,
            IEmpRelativesAsColleaguesDetailsRepository empRelativesAsColleaguesDetailsRepository)
        {
            _loaAddendumAcceptanceDetailsRepository = loaAddendumAcceptanceDetailsRepository;
            _empRelativesAsColleaguesDetailsRepository = empRelativesAsColleaguesDetailsRepository;
        }

        public async Task<IActionResult> Index()
        {
            LoaAddendumAcceptanceDetailOut details = await _loaAddendumAcceptanceDetailsRepository.LoaAddendumAcceptanceDetailsAsync(
                           BaseSpTcmPLGet(),new ParameterSpTcmPL());

            EmpRelativesAsColleaguesDetailOut EmpRelativesAsColleaguesDetails = await _empRelativesAsColleaguesDetailsRepository.EmpRelativesAsColleaguesDetailsAsync(
                           BaseSpTcmPLGet(), new ParameterSpTcmPL());

            ViewData["AddendumAcceptanceRating"] = details.PAddendumAcceptanceRating;
            ViewData["EmpRelativeRating"] = EmpRelativesAsColleaguesDetails.PEmpRelativesRating;
            return View();
        }
    }
}