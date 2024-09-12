using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models;
using TCMPLApp.WebApp.CustomPolicyProvider;
using static TCMPLApp.WebApp.Classes.DTModel;
using TCMPLApp.DataAccess.Repositories.Utilities;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.Utilities;
using TCMPLApp.WebApp.Models;
using Newtonsoft.Json;
using TCMPLApp.DataAccess.Repositories.Common;

namespace TCMPLApp.WebApp.Controllers
{
    public class CostcodeListController : BaseController
    {
        private const string ConstFilterCostcodeListIndex = "Index";

        private readonly IFilterRepository _filterRepository;
        private readonly ICostcodeListDataTableListRepository _costcodeListDataTableListRepository;

        public CostcodeListController(IFilterRepository filterRepository,
                                      ICostcodeListDataTableListRepository costcodeListDataTableListRepository)
        {
            _filterRepository = filterRepository;
            _costcodeListDataTableListRepository = costcodeListDataTableListRepository;
        }

        [HttpGet]        
        public async Task<IActionResult> Index()
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterCostcodeListIndex
            });

            CostcodeListViewModel costcodeListViewModel = new CostcodeListViewModel();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                costcodeListViewModel.FilterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            return View(costcodeListViewModel);
        }

        [HttpGet]        
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetCostcodeListDataTable(DTParameters param)
        {
            int totalRow = 0;

            DTResult<CostcodeListDataTableList> result = new DTResult<CostcodeListDataTableList>();

            try
            {
                var data = await _costcodeListDataTableListRepository.CostcodeListDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,                        
                        PGenericSearch = param.GenericSearch ?? " "
                    }
                );

                if (data.Any())
                {
                    totalRow = (int)data.FirstOrDefault().TotalRow.Value;
                }

                result.draw = param.Draw;
                result.recordsTotal = totalRow;
                result.recordsFiltered = totalRow;
                result.data = data.ToList();

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
    }
}