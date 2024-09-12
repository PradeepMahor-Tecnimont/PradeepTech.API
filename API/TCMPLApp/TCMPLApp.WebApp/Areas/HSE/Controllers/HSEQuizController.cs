using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HSE;
using TCMPLApp.Domain.Models.EmpGenInfo;
using TCMPLApp.Domain.Models.HSE;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.HSE.Controllers
{
    [Authorize]
    [Area("HSE")]
    public class HSEQuizController : BaseController
    {
        private readonly IHSEQuizDataTableListRepository _hSEQuizDataTableListRepository;
        private readonly IHSEQuizRepository _hSEQuizRepository;
        private readonly IHSEQuizDetailsRepository _hSEQuizDetailsRepository;

        public HSEQuizController(
            IHSEQuizDataTableListRepository hSEQuizDataTableListRepository,
            IHSEQuizRepository hSEQuizRepository,
            IHSEQuizDetailsRepository hSEQuizDetailsRepository
            )
        {
            _hSEQuizDataTableListRepository = hSEQuizDataTableListRepository;
            _hSEQuizRepository = hSEQuizRepository;
            _hSEQuizDetailsRepository = hSEQuizDetailsRepository;
        }

        public async Task<IActionResult> HSEQuizIndex()
        {

            HSEQuizDetailOut details = await _hSEQuizDetailsRepository.HSEQuizDetailsAsync(
                           BaseSpTcmPLGet(),
                           new ParameterSpTcmPL());

            DTResult<HSEQuizDataTableList> result = new DTResult<HSEQuizDataTableList>();

            var data = await _hSEQuizDataTableListRepository.HSEQuizDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = 0,
                        PPageLength = 1000,
                        PQuizId = details.PQuizId,
                    }
                );

            if (data == null || data.Count() == 0) { throw new Exception("No Data Found"); }

            var QuizData = new HSEQuizViewModel
            {
                Result = data,
                QuizId = details.PQuizId
            };
            ViewData["QuizTitle"] = details.PDescription;
            return View(QuizData);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> HSEQuizAnsSubmit([FromForm] HSEQuizAnsSubmitViewModel hSEQuizAnsSubmitViewModel)
        {
            if (ModelState.IsValid)
            {
                Domain.Models.Common.DBProcMessageOutput result = await _hSEQuizRepository.HSEQuizSaveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PQuizId = hSEQuizAnsSubmitViewModel.QuizId,
                        PAnswerId1 = hSEQuizAnsSubmitViewModel.AnswerId1,
                        PQuestionId1 = hSEQuizAnsSubmitViewModel.QuestionId1,
                        PAnswerId2 = hSEQuizAnsSubmitViewModel.AnswerId2,
                        PQuestionId2 = hSEQuizAnsSubmitViewModel.QuestionId2,
                        PAnswerId3 = hSEQuizAnsSubmitViewModel.AnswerId3,
                        PQuestionId3 = hSEQuizAnsSubmitViewModel.QuestionId3,
                        PAnswerId4 = hSEQuizAnsSubmitViewModel.AnswerId4,
                        PQuestionId4 = hSEQuizAnsSubmitViewModel.QuestionId4,
                        PAnswerId5 = hSEQuizAnsSubmitViewModel.AnswerId5,
                        PQuestionId5 = hSEQuizAnsSubmitViewModel.QuestionId5,
                        PAnswerId6 = hSEQuizAnsSubmitViewModel.AnswerId6,
                        PQuestionId6 = hSEQuizAnsSubmitViewModel.QuestionId6,
                        PAnswerId7 = hSEQuizAnsSubmitViewModel.AnswerId7,
                        PQuestionId7 = hSEQuizAnsSubmitViewModel.QuestionId7,
                        PAnswerId8 = hSEQuizAnsSubmitViewModel.AnswerId8,
                        PQuestionId8 = hSEQuizAnsSubmitViewModel.QuestionId8,
                        PAnswerId9 = hSEQuizAnsSubmitViewModel.AnswerId9,
                        PQuestionId9 = hSEQuizAnsSubmitViewModel.QuestionId9,
                        PAnswerId10 = hSEQuizAnsSubmitViewModel.AnswerId10,
                        PQuestionId10 = hSEQuizAnsSubmitViewModel.QuestionId10,
                    });
                if (result.PMessageType == IsOk)
                {
                    Notify("Success", "Procedure executed successfully", "", NotificationType.success);
                    return RedirectToAction("HSEQuizIndex");
                }
                else
                {
                    Notify("Error", result.PMessageText, "", NotificationType.error);
                }

            }
            return View(hSEQuizAnsSubmitViewModel);
        }
    }
}
