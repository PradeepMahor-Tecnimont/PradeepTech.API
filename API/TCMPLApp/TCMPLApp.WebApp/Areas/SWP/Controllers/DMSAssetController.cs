using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.SWP;
using TCMPLApp.Domain.Models.SWP;
using TCMPLApp.WebApp.Controllers;
//using TCMPLApp.WebApp.Lib.Models;
using static TCMPLApp.WebApp.Classes.DTModel;
using TCMPLApp.WebApp.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{    
    [Area("SWP")]
    public class DMSAssetController : BaseController
    { 
        private readonly IDMSAsset2HomeDataTableListRepository _dmsAsset2HomeDataTableListRepository;
        private readonly IDMSAsset2HomeDetailRepository _dmsAsset2HomeDetailRepository;
        private readonly IDMSOrphanAssetDataTableListRepository _dmsOrphanAssetDataTableListRepository;
        private readonly IDMSOrphanAssetDetailRepository _dmsOrphanAssetDetailRepository;
        private readonly IDMSOrphanAssetUpdateRepository _dmsOrphanAssetUpdateRepository;
        private readonly IDMSAsset2HomeUpdateRepository _dmsAsset2HomeUpdateRepository;
        private readonly IAttendanceEmployeeDetailsRepository _attendanceEmployeeDetailsRepository;


        public DMSAssetController(IDMSAsset2HomeDetailRepository dmsAsset2HomeDetailRepository,
                                  IDMSAsset2HomeDataTableListRepository dmsAsset2HomeDataTableListRepository,
                                  IDMSOrphanAssetDataTableListRepository dmsOrphanAssetDataTableListRepository,
                                  IDMSOrphanAssetDetailRepository dmsOrphanAssetDetailRepository,
                                  IDMSOrphanAssetUpdateRepository dmsOrphanAssetUpdateRepository,
                                  IDMSAsset2HomeUpdateRepository dmsAsset2HomeUpdateRepository,
                                  IAttendanceEmployeeDetailsRepository attendanceEmployeeDetailsRepository)
        {
            _dmsAsset2HomeDataTableListRepository = dmsAsset2HomeDataTableListRepository;
            _dmsAsset2HomeDetailRepository = dmsAsset2HomeDetailRepository;            
            _dmsOrphanAssetDataTableListRepository = dmsOrphanAssetDataTableListRepository;
            _dmsOrphanAssetDetailRepository = dmsOrphanAssetDetailRepository;
            _dmsOrphanAssetUpdateRepository = dmsOrphanAssetUpdateRepository;
            _dmsAsset2HomeUpdateRepository = dmsAsset2HomeUpdateRepository;
            _attendanceEmployeeDetailsRepository = attendanceEmployeeDetailsRepository;
        }

        public IActionResult Index()
        {
            return View();
        }

        #region AssetsTaken2home

        public IActionResult Asset2HomeIndex()
        {
            return View();
        }

        //[HttpGet]
        //[ValidateAntiForgeryToken]
        //public async Task<JsonResult> GetListAsset2HomeRequests(DTParameters param)
        //{
        //    DTResult<DMSAssetTakeHomeDataTableList> result = new DTResult<DMSAssetTakeHomeDataTableList>();
        //    int totalRow = 0;

        //    try
        //    {
        //        var data = await _dmsAsset2HomeDataTableListRepository.DeskAssetTakeHomeDataTableList(
        //            BaseSpTcmPLGet(),
        //            new ParameterSpTcmPL
        //            {
        //                PRowNumber = param.Start,
        //                PPageLength = param.Length,
        //                PUnqid = param.Unqid
        //            }
        //        );

        //        if (data.Any())
        //        {
        //            totalRow = (int)data.FirstOrDefault().TotalRow.Value;
        //        }

        //        result.draw = param.Draw;
        //        result.recordsTotal = totalRow;
        //        result.recordsFiltered = totalRow;
        //        result.data = data.ToList();

        //        return Json(result);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Json(new { error = ex.Message });
        //    }
        //}

        //[HttpGet]
        //[ValidateAntiForgeryToken]
        //public async Task<JsonResult> ConfirmAsset2Home(DTParameters param)
        //{
        //    DTResult<DMSAssetTakeHome> result = new DTResult<DMSAssetTakeHome>();
        //    int totalRow = 0;

        //    try
        //    {
        //        var data = await _dmsAsset2HomeDetailRepository.DeskAssetTakeHomeDetail(
        //            BaseSpTcmPLGet(),
        //            new ParameterSpTcmPL
        //            {
        //                PRowNumber = param.Start,
        //                PPageLength = param.Length,
        //                PUnqid = param.Unqid
        //            }
        //        );

        //        if (data.Any())
        //        {
        //            totalRow = (int)data.FirstOrDefault().TotalRow.Value;
        //        }

        //        result.draw = param.Draw;
        //        result.recordsTotal = totalRow;
        //        result.recordsFiltered = totalRow;
        //        result.data = data.ToList();

        //        return Json(result);
        //    }
        //    catch (Exception ex)
        //    {
        //        return Json(new { error = ex.Message });
        //    }
        //}

        [HttpGet]
        //[ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListAsset2HomeRequests(DTParameters param)
        {
            DTResult<DMSAssetTakeHomeDataTableList> result = new DTResult<DMSAssetTakeHomeDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _dmsAsset2HomeDataTableListRepository.AssetTakeHomeDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length
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

        public async Task<IActionResult> Asset2HomeDetailModal(string Unqid, string Empno, string Deskid)
        {
            var dmsAssetTakeHomeDetailViewModel = new DMSAssetTakeHomeDetailViewModel();
            dmsAssetTakeHomeDetailViewModel.Unqid = Unqid;

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = Empno
                               }
                           );
            ViewData["Empno"] = Empno.ToString();
            ViewData["EmpName"] = empdetails.Name.ToString();
            ViewData["Deskid"] = Deskid.ToString();

            return PartialView("_ModalAsset2HomeConfirmPartial", dmsAssetTakeHomeDetailViewModel);
        }


        [HttpGet]
        //[ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListConfirmAsset2Home(DTParameters param)
        {
            DTResult<DMSAssetTakeHome> result = new DTResult<DMSAssetTakeHome>();
            int totalRow = 0;

            try
            {
                var data = await _dmsAsset2HomeDetailRepository.AssetTakeHomeDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PUnqid = param.Unqid
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
        //ValidateAntiForgeryToken]
        public async Task<IActionResult> PostListConfirmAsset2Home(AssetData[] assetData)
        {
            try
            {
                var resultObjArray = ToArray(assetData);
                //UserIdentity currentUserIdentity = CurrentUserIdentity;
                var result = await _dmsAsset2HomeUpdateRepository.Asset2HomeUpdate(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PAssetToHomeArray = resultObjArray.ToArray()
                          });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }


        #endregion AssetsTaken2home

        #region OrphanAsset

        public IActionResult OrphanAssetIndex()
        {
            return View();
        }

        [HttpGet]
        //[ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListOrphanAssetRequests(DTParameters param)
        {
            DTResult<DMSOrphanAssetDataTableList> result = new DTResult<DMSOrphanAssetDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _dmsOrphanAssetDataTableListRepository.OrphanAssetDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length
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

        public async Task<IActionResult> OrphanAssetDetailModal(string Unqid, string Empno, string Deskid)
        {
            var dmsOrphanAssetDetailViewModel = new DMSOrphanAssetDetailViewModel();
            dmsOrphanAssetDetailViewModel.Unqid = Unqid;

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = Empno
                               }
                           );
            ViewData["Empno"] = Empno.ToString();
            ViewData["EmpName"] = empdetails.Name.ToString();
            ViewData["Deskid"] = Deskid.ToString();

            return PartialView("_ModalOrphanAssetConfirmPartial", dmsOrphanAssetDetailViewModel);
        }

        [HttpGet]
        //[ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListConfirmOrphanAsset(DTParameters param)
        {
            DTResult<DMSOrphanAsset> result = new DTResult<DMSOrphanAsset>();
            int totalRow = 0;

            try
            {
                var data = await _dmsOrphanAssetDetailRepository.OrphanAssetDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PUnqid = param.Unqid
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
        //ValidateAntiForgeryToken]
        public async Task<IActionResult> PostListConfirmOrphanAsset(AssetData[] assetData)
        {
            try
            {
                var resultObjArray = ToArray(assetData);
                //UserIdentity currentUserIdentity = CurrentUserIdentity;
                var result = await _dmsOrphanAssetUpdateRepository.OrphanAssetUpdate(
                          BaseSpTcmPLGet(),
                          new ParameterSpTcmPL
                          {
                              PAssetToHomeArray = resultObjArray.ToArray()
                          });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }


        #endregion OrphanAsset

        #region GatePass

        public IActionResult GatePassIndex()
        {
            return View();
        }

        [HttpGet]
        //[ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListGatePass(DTParameters param)
        {
            DTResult<DMSAssetTakeHomeDataTableList> result = new DTResult<DMSAssetTakeHomeDataTableList>();
            int totalRow = 0;

            try
            {
                var data = await _dmsAsset2HomeDataTableListRepository.GatePassDataTableList(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length
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

        [HttpGet]
        public async Task<IActionResult> GatePassDetailModal(string Unqid, string Empno, string Deskid)
        {
            var dmsAssetTakeHomeDetailViewModel = new DMSAssetTakeHomeDetailViewModel();
            dmsAssetTakeHomeDetailViewModel.Unqid = Unqid;

            var empdetails = await _attendanceEmployeeDetailsRepository.AttendanceEmployeeDetailsAsync(BaseSpTcmPLGet(),
                               new ParameterSpTcmPL
                               {
                                   PEmpno = Empno
                               }
                           );

            ViewData["Empno"] = Empno.ToString();
            ViewData["EmpName"] = empdetails.Name.ToString();
            ViewData["Deskid"] = Deskid.ToString();

            return PartialView("_ModalGatepassPartial", dmsAssetTakeHomeDetailViewModel);
        }

        [HttpGet]
        //[ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListGatepassModal(DTParameters param)
        {
            DTResult<DMSAssetTakeHome> result = new DTResult<DMSAssetTakeHome>();
            int totalRow = 0;

            try
            {
                var data = await _dmsAsset2HomeDetailRepository.GatepassDetail(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PRowNumber = param.Start,
                        PPageLength = param.Length,
                        PUnqid = param.Unqid
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


        #endregion GatePass
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