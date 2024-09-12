using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Domain.Models.SelfService;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
//using TCMPLApp.WebApp.Lib.Models;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Authorize]
    [Area("DMS")]
    public class DMSEmpController : BaseController
    {
        private readonly IDMSEmployeeRepository _dmsEmployeeRepository;
        private readonly IDMSAsset2HomeRepository _dmsAsset2HomeRepository;

        public DMSEmpController(IDMSEmployeeRepository dmsEmployeeRepository, IDMSAsset2HomeRepository dmsAsset2HomeRepository)
        {
            _dmsEmployeeRepository = dmsEmployeeRepository;
            _dmsAsset2HomeRepository = dmsAsset2HomeRepository;
        }

        public IActionResult Asset2Home()
        {
            Asset2HomeIndexViewModel asset2HomeIndexViewModel = new Asset2HomeIndexViewModel();
            return View(asset2HomeIndexViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListDeskAssets(DTParameters param)
        {
            DTResult<DeskAssetTakeHomeDetail> result = new DTResult<DeskAssetTakeHomeDetail>();
            int totalRow = 0;
            UserIdentity currentUserIdentity = CurrentUserIdentity;
            try
            {
                var data = await _dmsEmployeeRepository.DeskAssetTakeHomeDetailList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PEmpno = currentUserIdentity.EmpNo
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
                return Json(new { error = ex.Message });
            }
        }

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public async Task<IActionResult> Asset2HomePost(AssetData[] assetData)
        {
            try
            {
                var resultObjArray = ToArray(assetData);
                UserIdentity currentUserIdentity = CurrentUserIdentity;
                var result = await _dmsAsset2HomeRepository.Asset2Home(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PAssetToHomeArray = resultObjArray.ToArray(),
                              PEmpno = currentUserIdentity.EmpNo
                          });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
       // [ValidateAntiForgeryToken]
        public async Task<IActionResult> Asset2HomeDiscardPost(string unqid)
        {
            try
            {                
                UserIdentity currentUserIdentity = CurrentUserIdentity;
                var result = await _dmsAsset2HomeRepository.Asset2HomeDiscard(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PUnqid = unqid,                             
                              PEmpno = currentUserIdentity.EmpNo
                          });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        private string[] ToArray(AssetData[] assetData)
        {
            List<string> listresultObj = new List<string>();

            string[] apprlValResult = assetData.Select(o => o.asset + "," + o.asset2Home).ToArray();

            if (assetData != null)
            {
                for (int i = 0; i < assetData.Length; i++)
                {
                    string temp1 = "";

                    temp1 = $"{assetData[i].asset}~!~{assetData[i].asset2Home}";

                    temp1 = temp1.Replace(";", "~!~");

                    listresultObj.Add(temp1);
                }
            }

            return listresultObj.ToArray();
        }
    }
}