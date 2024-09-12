using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.WebApp.Controllers;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [Area("HRMasters")]
    public class HomeController : BaseController
    {
        IHRMastersRepository _mastersRepository;
        IHolidayMasterViewRepository _holidaymasterViewRepository;
        IHRMastersViewRepository _hrmastersViewRepository;

        public HomeController(IHRMastersRepository mastersRepository,
            IHolidayMasterViewRepository holidaymasterViewRepository,
            IHRMastersViewRepository hrmastersViewRepository)
        {
            _mastersRepository = mastersRepository;
            _holidaymasterViewRepository = holidaymasterViewRepository;
            _hrmastersViewRepository = hrmastersViewRepository;
        }

        public async Task<IActionResult> Index()
        {
            ViewData["EmployeeCount"] = await _mastersRepository.GetEmloyeeCount();
            ViewData["CostcodeCount"] = await _mastersRepository.GetCostcodeCount();
            return View();
        }

        public async Task<IActionResult> Index2()
        {
            ViewData["HolidayCount"] = await _holidaymasterViewRepository.GetHolidayCount();
            ViewData["DesignationCount"] = await _hrmastersViewRepository.GetDesignationCount();
            ViewData["BankcodeCount"] = await _hrmastersViewRepository.GetBankcodeCount();
            ViewData["CategoryCount"] = await _hrmastersViewRepository.GetCategoryCount();
            ViewData["EmptypeCount"] = await _hrmastersViewRepository.GetEmptypeCount();
            ViewData["GradeCount"] = await _hrmastersViewRepository.GetGradeCount();
            ViewData["LocationCount"] = await _hrmastersViewRepository.GetLocationCount();
            ViewData["OfficeCount"] = await _hrmastersViewRepository.GetOfficeCount();
            ViewData["SubcontractCount"] = await _hrmastersViewRepository.GetSubcontractCount();
            ViewData["PlaceCount"] = await _hrmastersViewRepository.GetPlaceCount();
            ViewData["QualificationCount"] = await _hrmastersViewRepository.GetQualificationCount();
            ViewData["GraduationCount"] = await _hrmastersViewRepository.GetGraduationCount();
            ViewData["JobGroupCount"] = await _hrmastersViewRepository.GetJobGroupCount();
            ViewData["JobDisciplineCount"] = await _hrmastersViewRepository.GetJobDisciplineCount();
            ViewData["JobTitleCount"] = await _hrmastersViewRepository.GetJobTitleCount();
            return View();
        }

        public IActionResult ReportIndex()
        {           
            return View();
        }

        public IActionResult UtilityIndex()
        {           
            return View();
        }

    }
}
