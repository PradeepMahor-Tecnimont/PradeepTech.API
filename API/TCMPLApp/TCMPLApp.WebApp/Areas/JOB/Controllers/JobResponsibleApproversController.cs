using ClosedXML.Excel;
using DocumentFormat.OpenXml.Drawing;
using DocumentFormat.OpenXml.Drawing.Charts;
using DocumentFormat.OpenXml.Office2010.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using Newtonsoft.Json;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Information;
using OfficeOpenXml.FormulaParsing.Excel.Functions.RefAndLookup;
using OfficeOpenXml.FormulaParsing.ExcelUtilities;
using OfficeOpenXml.FormulaParsing.ExpressionGraph;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.JOB;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.JOB;
using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Areas.HRMasters.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using TCMPLApp.WebApp.Services;
using static ClosedXML.Excel.XLPredefinedFormat;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.JOB.Controllers
{
    //[Authorize]
    [Area("JOB")]
    public class JobResponsibleApprovers : BaseController
    {
        private const string ConstR01 = "R01";
        private const string ConstR02 = "R02";
        private const string ConstR03 = "R03";
        private const string ConstR04 = "R04";
        private const string ConstR05 = "R05";
        private const string ConstR06 = "R06";
        private const string ConstR07 = "R07";
        private const string ConstR08 = "R08";
        private const string ConstR09 = "R09";
        private const string ConstR10 = "R10";
        private const string ConstR11 = "R11";

        private readonly IConfiguration _configuration;
        private readonly IFilterRepository _filterRepository;
        private readonly IHttpClientRapReporting _httpClientRapReporting;
        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IJobResponsibleApproversDetailRepository _jobResponsibleApproversDetailRepository;
        private readonly IJobResponsibleApproversRepository _jobResponsibleApproversRepository;
        private readonly IJobResponsibleApproversListRepository _jobResponsibleApproversListRepository;
        private readonly IJobResponsibleActionsListRepository _jobResponsibleActionsListRepository;
        private readonly IJobValidateStatusRepository _jobValidateStatusRepository;

        public JobResponsibleApprovers(IConfiguration configuration,
                             IFilterRepository filterRepository,
                             IHttpClientRapReporting httpClientRapReporting,
                             ISelectTcmPLRepository selectTcmPLRepository,
                             IJobResponsibleApproversDetailRepository jobResponsibleApproversDetailRepository,
                             IJobResponsibleApproversRepository jobResponsibleApproversRepository,
                             IJobResponsibleApproversListRepository jobResponsibleApproversListRepository,
                             IJobResponsibleActionsListRepository jobResponsibleActionsListRepository,
                             IJobValidateStatusRepository jobValidateStatusRepository)
        {
            _configuration = configuration;
            _filterRepository = filterRepository;
            _httpClientRapReporting = httpClientRapReporting;
            _selectTcmPLRepository = selectTcmPLRepository;
            _jobResponsibleApproversDetailRepository = jobResponsibleApproversDetailRepository;
            _jobResponsibleApproversRepository = jobResponsibleApproversRepository;
            _jobResponsibleApproversListRepository = jobResponsibleApproversListRepository;
            _jobResponsibleActionsListRepository = jobResponsibleActionsListRepository;
            _jobValidateStatusRepository = jobValidateStatusRepository;
        }

        #region Responsible / Approvers

        private async Task<IEnumerable<ProfileAction>> EmployeeProjActions(string id)
        {
            var actionsList = await _jobResponsibleActionsListRepository.JobResponsibleActionsList(BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id
                });
            return actionsList;
        }

        #region CRUD

        [HttpGet]        
        public async Task<IActionResult> ResponsibleApproversIndex(string id)
        {
            if (id == null)
                return NotFound();

            var projectActions = await EmployeeProjActions(id);

            JobResponsibleApproversIndexViewModel jobResponsibleApproversIndexViewModel = new JobResponsibleApproversIndexViewModel
            {
                ProjectActions = projectActions,
                Projno = id
            };             
            
            return PartialView("_ResponsibleApproversIndexPartial", jobResponsibleApproversIndexViewModel);           
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetResponsibleApproversList(string paramJson)
        {            
            //DTResult <JobResponsibleApproversList> result = new DTResult<JobResponsibleApproversList>();
            DTResultExtension<JobResponsibleApproversList, JobValidateStatusOutput> result = new DTResultExtension<JobResponsibleApproversList, JobValidateStatusOutput>();
            try
            {
                var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

                var jobValidateStatus = await _jobValidateStatusRepository.ValidateStatusAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = param.Projno
                    }
                );

                var data = await _jobResponsibleApproversListRepository.JobResponsibleApproversList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = param.Projno
                    }
                );                

                result.draw = param.Draw;                
                result.data = data.ToList();
                result.headerData = jobValidateStatus;

                return Json(result);
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    error = ex.Message
                });
            }
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobChangeResponsibleMngr)]
        public async Task<IActionResult> ResponsibleApproversEdit(string id)
        {
            if (id == null)
                return NotFound();

            JobResponsibleApproversEditViewModel jobResponsibleApproversEditViewModel = new();

            var result = await _jobResponsibleApproversDetailRepository.ResponsibleApproversDetailAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id
                });            

            if (result.PMessageType == IsOk)
            {
                jobResponsibleApproversEditViewModel.Projno = id;
                jobResponsibleApproversEditViewModel.EmpnoR01 = result.PEmpnoR01;
                jobResponsibleApproversEditViewModel.EmpnoNameR01 = result.PEmpnoNameR01;
                jobResponsibleApproversEditViewModel.EmpnoR02 = result.PEmpnoR02;
                jobResponsibleApproversEditViewModel.EmpnoR03 = result.PEmpnoR03;
                jobResponsibleApproversEditViewModel.EmpnoR04 = result.PEmpnoR04;
                jobResponsibleApproversEditViewModel.EmpnoR05 = result.PEmpnoR05;
                jobResponsibleApproversEditViewModel.EmpnoR05RequiredAttribute = result.PEmpnoR05RequiredAttribute;
                jobResponsibleApproversEditViewModel.EmpnoR06 = result.PEmpnoR06;
                jobResponsibleApproversEditViewModel.EmpnoR06RequiredAttribute = result.PEmpnoR06RequiredAttribute;
                jobResponsibleApproversEditViewModel.EmpnoR07 = result.PEmpnoR07;
                jobResponsibleApproversEditViewModel.EmpnoR07RequiredAttribute = result.PEmpnoR07RequiredAttribute;
                jobResponsibleApproversEditViewModel.EmpnoR08 = result.PEmpnoR08;
                jobResponsibleApproversEditViewModel.EmpnoR08RequiredAttribute = result.PEmpnoR08RequiredAttribute;

                //if (result.PMessageText == NoDataFound)
                //{
                //    var resultR05R06 = await _jobResponsibleApproversDetailRepository.ResponsibleR05R06Async(
                //    BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PProjno = id
                //    });
                //    jobResponsibleApproversEditViewModel.EmpnoR05 = resultR05R06.PEmpnoR05;
                //    jobResponsibleApproversEditViewModel.EmpnoR06 = resultR05R06.PEmpnoR06;
                //}

                #region select list

                //var jobResponsibleR01 = await _selectTcmPLRepository.JobResponsibleListAsync(
                //    BaseSpTcmPLGet(),
                //    new ParameterSpTcmPL
                //    {
                //        PProjno = id,
                //        PJobResponsibleRoleId = ConstR01
                //    });
                var jobResponsibleR02 = await _selectTcmPLRepository.JobResponsibleListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id,
                        PJobResponsibleRoleId = ConstR02
                    });
                var jobResponsibleR03 = await _selectTcmPLRepository.JobResponsibleListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id,
                        PJobResponsibleRoleId = ConstR03
                    });
                var jobResponsibleR04 = await _selectTcmPLRepository.JobResponsibleListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id,
                        PJobResponsibleRoleId = ConstR04
                    });
                var jobResponsibleR05 = await _selectTcmPLRepository.JobResponsibleListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id,
                        PJobResponsibleRoleId = ConstR05
                    });
                var jobResponsibleR06 = await _selectTcmPLRepository.JobResponsibleListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id,
                        PJobResponsibleRoleId = ConstR06
                    });
                var jobResponsibleR07 = await _selectTcmPLRepository.JobResponsibleListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id,
                        PJobResponsibleRoleId = ConstR07
                    });
                var jobResponsibleR08 = await _selectTcmPLRepository.JobResponsibleListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PProjno = id,
                        PJobResponsibleRoleId = ConstR08
                    });

                //ViewData["EmpnoR01"] = new SelectList(jobResponsibleR01, "DataValueField", "DataTextField");
                ViewData["EmpnoR02"] = new SelectList(jobResponsibleR02, "DataValueField", "DataTextField");
                ViewData["EmpnoR03"] = new SelectList(jobResponsibleR03, "DataValueField", "DataTextField");
                ViewData["EmpnoR04"] = new SelectList(jobResponsibleR04, "DataValueField", "DataTextField");
                ViewData["EmpnoR05"] = new SelectList(jobResponsibleR05, "DataValueField", "DataTextField");
                ViewData["EmpnoR06"] = new SelectList(jobResponsibleR06, "DataValueField", "DataTextField");
                ViewData["EmpnoR07"] = new SelectList(jobResponsibleR07, "DataValueField", "DataTextField");
                ViewData["EmpnoR08"] = new SelectList(jobResponsibleR08, "DataValueField", "DataTextField");

                #endregion select list
            }          
            return PartialView("_ModalResponsibleApproversEditPartial", jobResponsibleApproversEditViewModel);
        }

        [HttpPost]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, JOBHelper.ActionJobChangeResponsibleMngr)]
        public async Task<IActionResult> ResponsibleApproversEdit([FromForm] JobResponsibleApproversEditViewModel jobResponsibleApproversEditViewModel)
        {
            var id = jobResponsibleApproversEditViewModel.Projno;

            try
            {                
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput result = await _jobResponsibleApproversRepository.UpdateResponsibleApproversAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PProjno = jobResponsibleApproversEditViewModel.Projno,
                            PEmpnoR01 = jobResponsibleApproversEditViewModel.EmpnoR01,
                            PEmpnoR02 = jobResponsibleApproversEditViewModel.EmpnoR02,
                            PEmpnoR03 = jobResponsibleApproversEditViewModel.EmpnoR03,
                            PEmpnoR04 = jobResponsibleApproversEditViewModel.EmpnoR04,
                            PEmpnoR05 = jobResponsibleApproversEditViewModel.EmpnoR05,
                            PEmpnoR06 = jobResponsibleApproversEditViewModel.EmpnoR06,
                            PEmpnoR07 = jobResponsibleApproversEditViewModel.EmpnoR07,
                            PEmpnoR08 = jobResponsibleApproversEditViewModel.EmpnoR08
                        });

                    return result.PMessageType != IsOk
                         ? throw new Exception(result.PMessageText.Replace("-", " "))
                         : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            #region select list

            //var jobResponsibleR01 = await _selectTcmPLRepository.JobResponsibleListAsync(
            //    BaseSpTcmPLGet(),
            //    new ParameterSpTcmPL
            //    {
            //        PProjno = id,
            //        PJobResponsibleRoleId = ConstR01
            //    });
            var jobResponsibleR02 = await _selectTcmPLRepository.JobResponsibleListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id,
                    PJobResponsibleRoleId = ConstR02
                });
            var jobResponsibleR03 = await _selectTcmPLRepository.JobResponsibleListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id,
                    PJobResponsibleRoleId = ConstR03
                });
            var jobResponsibleR04 = await _selectTcmPLRepository.JobResponsibleListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id,
                    PJobResponsibleRoleId = ConstR04
                });
            var jobResponsibleR05 = await _selectTcmPLRepository.JobResponsibleListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id,
                    PJobResponsibleRoleId = ConstR05
                });
            var jobResponsibleR06 = await _selectTcmPLRepository.JobResponsibleListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id,
                    PJobResponsibleRoleId = ConstR06
                });
            var jobResponsibleR07 = await _selectTcmPLRepository.JobResponsibleListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id,
                    PJobResponsibleRoleId = ConstR07
                });
            var jobResponsibleR08 = await _selectTcmPLRepository.JobResponsibleListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PProjno = id,
                    PJobResponsibleRoleId = ConstR08
                });
            //ViewData["EmpnoR01"] = new SelectList(jobResponsibleR01, "DataValueField", "DataTextField");
            ViewData["EmpnoR02"] = new SelectList(jobResponsibleR02, "DataValueField", "DataTextField");
            ViewData["EmpnoR03"] = new SelectList(jobResponsibleR03, "DataValueField", "DataTextField");
            ViewData["EmpnoR04"] = new SelectList(jobResponsibleR04, "DataValueField", "DataTextField");
            ViewData["EmpnoR05"] = new SelectList(jobResponsibleR05, "DataValueField", "DataTextField");
            ViewData["EmpnoR06"] = new SelectList(jobResponsibleR06, "DataValueField", "DataTextField");
            ViewData["EmpnoR07"] = new SelectList(jobResponsibleR07, "DataValueField", "DataTextField");
            ViewData["EmpnoR08"] = new SelectList(jobResponsibleR08, "DataValueField", "DataTextField");

            #endregion select list

            return PartialView("_ModalResponsibleApproversEditPartial", jobResponsibleApproversEditViewModel);
        }

        #endregion CRUD

        #endregion Responsible / Approvers


    }
}
