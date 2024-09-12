using ClosedXML.Excel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.HRMasters;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.WebApp.Areas.HRMasters.Models;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;

//using TCMPLApp.WebApp.Lib.Models;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;

namespace TCMPLApp.WebApp.Areas.HRMasters.Controllers
{
    [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditHRMasters)]
    [Area("HRMasters")]
    public class OthersController : BaseController
    {
        private readonly IConfiguration _configuration;
        private readonly IHRMastersRepository _hrmastersRepository;
        private readonly IHRMastersViewRepository _hrmastersViewRepository;
        private readonly ISelectRepository _selectRepository;

        public OthersController(IConfiguration configuration,
                                IHRMastersRepository hrmastersRepository,
                                IHRMastersViewRepository hrmastersViewRepository,
                                ISelectRepository selectRepository)
        {
            _configuration = configuration;
            _hrmastersRepository = hrmastersRepository;
            _hrmastersViewRepository = hrmastersViewRepository;
            _selectRepository = selectRepository;
        }

        #region >>>>>>>>>>> D E S I G N A T I O N   M A S T E R <<<<<<<<<<<<<<

        public IActionResult Designations()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetDesignationList(string paramJson)
        {
            DTResult<DesignationMaster> result = new();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetDesignationMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => t.Desgcode.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            || t.Desg.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            || (!string.IsNullOrWhiteSpace(t.Ord) && t.Ord.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            || (!string.IsNullOrWhiteSpace(t.Subcode) && t.Subcode.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult DesignationCreate()
        {
            DesignationCreateViewModel designationCreateViewModel = new();

            return PartialView("_ModalDesignationCreatePartial", designationCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> DesignationCreate([FromForm] DesignationCreateViewModel designationCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DesignationMasterAdd designationMasterAdd = new()
                    {
                        PDesgcode = designationCreateViewModel.Desgcode,
                        PDesg = designationCreateViewModel.Desg,
                        POrd = designationCreateViewModel.Ord,
                        PSubcode = designationCreateViewModel.Subcode,
                        PDesgNew = designationCreateViewModel.DesgNew
                    };

                    var retVal = await _hrmastersRepository.AddDesignation(designationMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalDesignationCreatePartial", designationCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> DesignationEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var model = new DesignationUpdateViewModel();

            var designationDetail = await _hrmastersViewRepository.DesignationDetail(id);

            if (designationDetail == null)
            {
                return NotFound();
            }

            model.Desgcode = designationDetail.Desgcode;
            model.Desg = designationDetail.Desg;
            model.DesgNew = designationDetail.DesgNew;
            model.Ord = designationDetail.Ord;
            model.Subcode = designationDetail.Subcode;

            return PartialView("_ModalDesignationUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> DesignationEdit([FromForm] DesignationUpdateViewModel designationUpdateViewModel)
        {
            var model = new DesignationUpdateViewModel();

            try
            {
                var designationDetail = await _hrmastersViewRepository.DesignationDetail(designationUpdateViewModel.Desgcode);

                model.Desgcode = designationDetail.Desgcode;
                model.Desg = designationDetail.Desg;
                model.DesgNew = designationDetail.DesgNew;
                model.Ord = designationDetail.Ord;
                model.Subcode = designationDetail.Subcode;

                if (ModelState.IsValid)
                {
                    DesignationMasterUpdate designationMasterUpdate = new()
                    {
                        PDesgcode = designationUpdateViewModel.Desgcode,
                        PDesg = designationUpdateViewModel.Desg,
                        PDesgNew = designationUpdateViewModel.DesgNew,
                        POrd = designationUpdateViewModel.Ord,
                        PSubcode = designationUpdateViewModel.Subcode
                    };

                    var retVal = await _hrmastersRepository.UpdateDesignation(designationMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalDesignationUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteDesignation(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            try
            {
                var designationDelete = new DesignationMasterDelete
                {
                    PDesgcode = id
                };

                var retVal = await _hrmastersRepository.DeleteDesignation(designationDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> DesignationExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersViewRepository.GetDesignationMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "DesignationMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.Worksheet(dt.TableName).Columns().AdjustToContents();
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("Designations");
        }

        #endregion >>>>>>>>>>> D E S I G N A T I O N   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<<

        public IActionResult BankcodeIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetBankcodeList(string paramJson)
        {
            DTResult<BankcodeMaster> result = new DTResult<BankcodeMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetBankcodeMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Bankcode.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Bankcodedesc) && t.Bankcodedesc.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult BankcodeCreate()
        {
            BankcodeCreateViewModel bankcodeCreateViewModel = new BankcodeCreateViewModel();

            return PartialView("_ModalBankcodeCreatePartial", bankcodeCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> BankcodeCreate([FromForm] BankcodeCreateViewModel bankcodeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    BankcodeMasterAdd bankcodeMasterAdd = new BankcodeMasterAdd
                    {
                        PBankcode = bankcodeCreateViewModel.Bankcode,
                        PBankcodedesc = bankcodeCreateViewModel.Bankcodedesc
                    };

                    var retVal = await _hrmastersRepository.AddBankcode(bankcodeMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalBankcodeCreatePartial", bankcodeCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> BankcodeEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new BankcodeUpdateViewModel();

            var bankcodeDetail = await _hrmastersViewRepository.BankcodeDetail(id);

            if (bankcodeDetail == null)
            {
                return NotFound();
            }

            model.Bankcode = bankcodeDetail.Bankcode;
            model.Bankcodedesc = bankcodeDetail.Bankcodedesc;

            return PartialView("_ModalBankcodeUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> BankcodeEdit([FromForm] BankcodeUpdateViewModel bankcodeUpdateViewModel)
        {
            var model = new BankcodeUpdateViewModel();

            try
            {
                var bankcodeDetail = await _hrmastersViewRepository.BankcodeDetail(bankcodeUpdateViewModel.Bankcode);

                model.Bankcode = bankcodeDetail.Bankcode;
                model.Bankcodedesc = bankcodeDetail.Bankcodedesc;

                if (ModelState.IsValid)
                {
                    BankcodeMasterUpdate bankcodeMasterUpdate = new BankcodeMasterUpdate
                    {
                        PBankcode = bankcodeUpdateViewModel.Bankcode,
                        PBankcodedesc = bankcodeUpdateViewModel.Bankcodedesc
                    };

                    var retVal = await _hrmastersRepository.UpdateBankcode(bankcodeMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalBankcodeUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteBankcode(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var bankcodeDelete = new BankcodeMasterDelete();

                bankcodeDelete.PBankcode = id;

                var retVal = await _hrmastersRepository.DeleteBankcode(bankcodeDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #endregion >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<<

        public IActionResult CategoryIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetCategoryList(string paramJson)
        {
            DTResult<CategoryMaster> result = new DTResult<CategoryMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetCategoryMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Categoryid.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Categorydesc) && t.Categorydesc.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult CategoryCreate()
        {
            CategoryCreateViewModel categoryCreateViewModel = new CategoryCreateViewModel();

            return PartialView("_ModalCategoryCreatePartial", categoryCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> CategoryCreate([FromForm] CategoryCreateViewModel categoryCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    CategoryMasterAdd categoryMasterAdd = new CategoryMasterAdd
                    {
                        PCategoryid = categoryCreateViewModel.Categoryid,
                        PCategorydesc = categoryCreateViewModel.Categorydesc
                    };

                    var retVal = await _hrmastersRepository.AddCategory(categoryMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalCategoryCreatePartial", categoryCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> CategoryEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new CategoryUpdateViewModel();

            var categoryDetail = await _hrmastersViewRepository.CategoryDetail(id);

            if (categoryDetail == null)
            {
                return NotFound();
            }

            model.Categoryid = categoryDetail.Categoryid;
            model.Categorydesc = categoryDetail.Categorydesc;

            return PartialView("_ModalCategoryUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> CategoryEdit([FromForm] CategoryUpdateViewModel categoryUpdateViewModel)
        {
            var model = new CategoryUpdateViewModel();

            try
            {
                var categoryDetail = await _hrmastersViewRepository.CategoryDetail(categoryUpdateViewModel.Categoryid);

                model.Categoryid = categoryDetail.Categoryid;
                model.Categorydesc = categoryDetail.Categorydesc;

                if (ModelState.IsValid)
                {
                    CategoryMasterUpdate categoryMasterUpdate = new CategoryMasterUpdate
                    {
                        PCategoryid = categoryUpdateViewModel.Categoryid,
                        PCategorydesc = categoryUpdateViewModel.Categorydesc
                    };

                    var retVal = await _hrmastersRepository.UpdateCategory(categoryMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalCategoryUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteCategory(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var categoryDelete = new CategoryMasterDelete();

                categoryDelete.PCategoryid = id;

                var retVal = await _hrmastersRepository.DeleteCategory(categoryDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #endregion >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<<

        public IActionResult EmptypeIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetEmptypeList(string paramJson)
        {
            DTResult<EmptypeMaster> result = new DTResult<EmptypeMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetEmptypeMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Emptype.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Empdesc) && t.Empdesc.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            | (!string.IsNullOrWhiteSpace(t.Empremarks) && t.Empremarks.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            | (!string.IsNullOrWhiteSpace(t.Sortorder) && t.Sortorder.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult EmptypeCreate()
        {
            EmptypeCreateViewModel emptypeCreateViewModel = new EmptypeCreateViewModel();

            return PartialView("_ModalEmptypeCreatePartial", emptypeCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> EmptypeCreate([FromForm] EmptypeCreateViewModel emptypeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    EmptypeMasterAdd emptypeMasterAdd = new EmptypeMasterAdd
                    {
                        PEmptype = emptypeCreateViewModel.Emptype,
                        PEmpdesc = emptypeCreateViewModel.Empdesc,
                        PEmpremarks = emptypeCreateViewModel.Empremarks,
                        PTm = emptypeCreateViewModel.Tm,
                        PPrintlogo = emptypeCreateViewModel.Printlogo,
                        PSortorder = emptypeCreateViewModel.Sortorder
                    };

                    var retVal = await _hrmastersRepository.AddEmptype(emptypeMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalEmptypeCreatePartial", emptypeCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> EmptypeEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new EmptypeUpdateViewModel();

            var emptypeDetail = await _hrmastersViewRepository.EmptypeDetail(id);

            if (emptypeDetail == null)
            {
                return NotFound();
            }

            model.Emptype = emptypeDetail.Emptype;
            model.Empdesc = emptypeDetail.Empdesc;
            model.Empremarks = emptypeDetail.Empremarks;
            model.Tm = emptypeDetail.Tm;
            model.Printlogo = emptypeDetail.Printlogo;
            model.Sortorder = emptypeDetail.Sortorder;

            return PartialView("_ModalEmptypeUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> EmptypeEdit([FromForm] EmptypeUpdateViewModel emptypeUpdateViewModel)
        {
            var model = new EmptypeUpdateViewModel();

            try
            {
                var emptypeDetail = await _hrmastersViewRepository.EmptypeDetail(emptypeUpdateViewModel.Emptype);

                model.Emptype = emptypeDetail.Emptype;
                model.Empdesc = emptypeDetail.Empdesc;
                model.Empremarks = emptypeDetail.Empremarks;
                model.Tm = emptypeDetail.Tm;
                model.Printlogo = emptypeDetail.Printlogo;
                model.Sortorder = emptypeDetail.Sortorder;

                if (ModelState.IsValid)
                {
                    EmptypeMasterUpdate emptypeMasterUpdate = new EmptypeMasterUpdate
                    {
                        PEmptype = emptypeUpdateViewModel.Emptype,
                        PEmpdesc = emptypeUpdateViewModel.Empdesc,
                        PEmpremarks = emptypeUpdateViewModel.Empremarks,
                        PTm = emptypeUpdateViewModel.Tm,
                        PPrintlogo = emptypeUpdateViewModel.Printlogo,
                        PSortorder = emptypeUpdateViewModel.Sortorder
                    };

                    var retVal = await _hrmastersRepository.UpdateEmptype(emptypeMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalEmptypeUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteEmptype(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var emptypeDelete = new EmptypeMasterDelete();

                emptypeDelete.PEmptype = id;

                var retVal = await _hrmastersRepository.DeleteEmptype(emptypeDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #endregion >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<<

        public IActionResult GradeIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetGradeList(string paramJson)
        {
            DTResult<GradeMaster> result = new DTResult<GradeMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetGradeMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Gradeid.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Gradedesc) && t.Gradedesc.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult GradeCreate()
        {
            GradeCreateViewModel gradeCreateViewModel = new GradeCreateViewModel();

            return PartialView("_ModalGradeCreatePartial", gradeCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> GradeCreate([FromForm] GradeCreateViewModel gradeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    GradeMasterAdd gradeMasterAdd = new GradeMasterAdd
                    {
                        PGradeId = gradeCreateViewModel.Gradeid,
                        PGradeDesc = gradeCreateViewModel.Gradedesc
                    };

                    var retVal = await _hrmastersRepository.AddGrade(gradeMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalGradeCreatePartial", gradeCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> GradeEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new GradeCreateViewModel();

            var gradeDetail = await _hrmastersViewRepository.GradeDetail(id);

            if (gradeDetail == null)
            {
                return NotFound();
            }

            model.Gradeid = gradeDetail.Gradeid;
            model.Gradedesc = gradeDetail.Gradedesc;

            return PartialView("_ModalGradeUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> GradeEdit([FromForm] GradeCreateViewModel gradeUpdateViewModel)
        {
            var model = new GradeCreateViewModel();

            try
            {
                var gradeDetail = await _hrmastersViewRepository.GradeDetail(gradeUpdateViewModel.Gradeid);

                model.Gradeid = gradeDetail.Gradeid;
                model.Gradedesc = gradeDetail.Gradedesc;

                if (ModelState.IsValid)
                {
                    GradeMasterUpdate gradeMasterUpdate = new GradeMasterUpdate
                    {
                        PGradeId = gradeUpdateViewModel.Gradeid,
                        PGradeDesc = gradeUpdateViewModel.Gradedesc
                    };

                    var retVal = await _hrmastersRepository.UpdateGrade(gradeMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalGradeUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteGrade(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var gradeDelete = new GradeMasterDelete();

                gradeDelete.PGradeId = id;

                var retVal = await _hrmastersRepository.DeleteGrade(gradeDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> GradeExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersViewRepository.GetGradeMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "GradeMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.Worksheet(dt.TableName).Columns().AdjustToContents();
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("GradeIndex");
        }

        #endregion >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<<

        public IActionResult OfficeIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetOfficeList(string paramJson)
        {
            DTResult<OfficeMaster> result = new DTResult<OfficeMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetOfficeMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Office.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Name) && t.Name.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult OfficeCreate()
        {
            OfficeCreateViewModel officeCreateViewModel = new OfficeCreateViewModel();

            return PartialView("_ModalOfficeCreatePartial", officeCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> OfficeCreate([FromForm] OfficeCreateViewModel officeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    OfficeMasterAdd officeMasterAdd = new OfficeMasterAdd
                    {
                        POffice = officeCreateViewModel.Office,
                        PName = officeCreateViewModel.Name
                    };

                    var retVal = await _hrmastersRepository.AddOffice(officeMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalOfficeCreatePartial", officeCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> OfficeEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new OfficeCreateViewModel();

            var officeDetail = await _hrmastersViewRepository.OfficeDetail(id);

            if (officeDetail == null)
            {
                return NotFound();
            }

            model.Office = officeDetail.Office;
            model.Name = officeDetail.Name;

            return PartialView("_ModalOfficeUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> OfficeEdit([FromForm] OfficeCreateViewModel officeUpdateViewModel)
        {
            var model = new OfficeCreateViewModel();

            try
            {
                var officeDetail = await _hrmastersViewRepository.OfficeDetail(officeUpdateViewModel.Office);

                model.Office = officeDetail.Office;
                model.Name = officeDetail.Name;

                if (ModelState.IsValid)
                {
                    OfficeMasterUpdate officeMasterUpdate = new OfficeMasterUpdate
                    {
                        POffice = officeUpdateViewModel.Office,
                        PName = officeUpdateViewModel.Name
                    };

                    var retVal = await _hrmastersRepository.UpdateOffice(officeMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalOfficeUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteOffice(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var officeDelete = new OfficeMasterDelete();

                officeDelete.POffice = id;

                var retVal = await _hrmastersRepository.DeleteOffice(officeDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #endregion >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<<

        public IActionResult LocationIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetLocationList(string paramJson)
        {
            DTResult<LocationMaster> result = new DTResult<LocationMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetLocationMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Locationid.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Location) && t.Location.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult LocationCreate()
        {
            LocationCreateViewModel locationCreateViewModel = new LocationCreateViewModel();

            return PartialView("_ModalLocationCreatePartial", locationCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> LocationCreate([FromForm] LocationCreateViewModel locationCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    LocationMasterAdd locationMasterAdd = new LocationMasterAdd
                    {
                        PLocationid = locationCreateViewModel.Locationid,
                        PLocation = locationCreateViewModel.Location
                    };

                    var retVal = await _hrmastersRepository.AddLocation(locationMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalLocationCreatePartial", locationCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> LocationEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new LocationCreateViewModel();

            var locationDetail = await _hrmastersViewRepository.LocationDetail(id);

            if (locationDetail == null)
            {
                return NotFound();
            }

            model.Locationid = locationDetail.Locationid;
            model.Location = locationDetail.Location;

            return PartialView("_ModalLocationUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> LocationEdit([FromForm] LocationCreateViewModel locationUpdateViewModel)
        {
            var model = new LocationCreateViewModel();

            try
            {
                var locationDetail = await _hrmastersViewRepository.LocationDetail(locationUpdateViewModel.Locationid);

                model.Locationid = locationDetail.Locationid;
                model.Location = locationDetail.Location;

                if (ModelState.IsValid)
                {
                    LocationMasterUpdate locationMasterUpdate = new LocationMasterUpdate
                    {
                        PLocationid = locationUpdateViewModel.Locationid,
                        PLocation = locationUpdateViewModel.Location
                    };

                    var retVal = await _hrmastersRepository.UpdateLocation(locationMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalLocationUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteLocation(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var locationDelete = new LocationMasterDelete();

                locationDelete.PLocationid = id;

                var retVal = await _hrmastersRepository.DeleteLocation(locationDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #endregion >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<<

        #region >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<<

        public IActionResult SubcontractIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetSubcontractList(string paramJson)
        {
            DTResult<SubcontractMaster> result = new DTResult<SubcontractMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetSubcontractMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Subcontract.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Description) && t.Description.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult SubcontractCreate()
        {
            SubcontractCreateViewModel subcontractCreateViewModel = new SubcontractCreateViewModel();

            return PartialView("_ModalSubcontractCreatePartial", subcontractCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> SubcontractCreate([FromForm] SubcontractCreateViewModel subcontractCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    SubcontractMasterAdd subcontractMasterAdd = new SubcontractMasterAdd
                    {
                        PSubcontract = subcontractCreateViewModel.Subcontract,
                        PDescription = subcontractCreateViewModel.Description
                    };

                    var retVal = await _hrmastersRepository.AddSubcontract(subcontractMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalSubcontractCreatePartial", subcontractCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> SubcontractEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new SubcontractCreateViewModel();

            var subcontractDetail = await _hrmastersViewRepository.SubcontractDetail(id);

            if (subcontractDetail == null)
            {
                return NotFound();
            }

            model.Subcontract = subcontractDetail.Subcontract;
            model.Description = subcontractDetail.Description;

            return PartialView("_ModalSubcontractUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> SubcontractEdit([FromForm] SubcontractCreateViewModel subcontractUpdateViewModel)
        {
            var model = new SubcontractCreateViewModel();

            try
            {
                var subcontractDetail = await _hrmastersViewRepository.SubcontractDetail(subcontractUpdateViewModel.Subcontract);

                model.Subcontract = subcontractDetail.Subcontract;
                model.Description = subcontractDetail.Description;

                if (ModelState.IsValid)
                {
                    SubcontractMasterUpdate subcontractMasterUpdate = new SubcontractMasterUpdate
                    {
                        PSubcontract = subcontractUpdateViewModel.Subcontract,
                        PDescription = subcontractUpdateViewModel.Description
                    };

                    var retVal = await _hrmastersRepository.UpdateSubcontract(subcontractMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalSubcontractUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteSubcontract(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var subcontractDelete = new SubcontractMasterDelete();

                subcontractDelete.PSubcontract = id;

                var retVal = await _hrmastersRepository.DeleteSubcontract(subcontractDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> SubcontractExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersViewRepository.GetSubcontractMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "SubcontractMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.Worksheet(dt.TableName).Columns().AdjustToContents();
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("SubcontractIndex");
        }

        #endregion >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<<

        #region Place master

        public IActionResult PlaceIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetPlaceList(string paramJson)
        {
            DTResult<PlaceMaster> result = new DTResult<PlaceMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetPlaceMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Placeid.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Placedesc) && t.Placedesc.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult PlaceCreate()
        {
            PlaceCreateViewModel placeCreateViewModel = new PlaceCreateViewModel();

            return PartialView("_ModalPlaceCreatePartial", placeCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> PlaceCreate([FromForm] PlaceCreateViewModel placeCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    PlaceMasterAdd placeMasterAdd = new PlaceMasterAdd
                    {
                        PPlaceId = placeCreateViewModel.Placeid,
                        PPlaceDesc = placeCreateViewModel.Placedesc
                    };

                    var retVal = await _hrmastersRepository.AddPlace(placeMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalPlaceCreatePartial", placeCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> PlaceEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new PlaceCreateViewModel();

            var placeDetail = await _hrmastersViewRepository.PlaceDetail(id);

            if (placeDetail == null)
            {
                return NotFound();
            }

            model.Placeid = placeDetail.Placeid;
            model.Placedesc = placeDetail.Placedesc;

            return PartialView("_ModalPlaceUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> PlaceEdit([FromForm] PlaceCreateViewModel placeUpdateViewModel)
        {
            var model = new PlaceCreateViewModel();

            try
            {
                var placeDetail = await _hrmastersViewRepository.PlaceDetail(placeUpdateViewModel.Placeid);

                model.Placeid = placeDetail.Placeid;
                model.Placedesc = placeDetail.Placedesc;

                if (ModelState.IsValid)
                {
                    PlaceMasterUpdate placeMasterUpdate = new PlaceMasterUpdate
                    {
                        PPlaceId = placeUpdateViewModel.Placeid,
                        PPlaceDesc = placeUpdateViewModel.Placedesc
                    };

                    var retVal = await _hrmastersRepository.UpdatePlace(placeMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalPlaceUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeletePlace(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var placeDelete = new PlaceMasterDelete();

                placeDelete.PPlaceId = id;

                var retVal = await _hrmastersRepository.DeletePlace(placeDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        #endregion Place master

        #region Qualification master

        public IActionResult QualificationIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetQualificationList(string paramJson)
        {
            DTResult<QualificationMaster> result = new DTResult<QualificationMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetQualificationMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Qualificationid.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Qualificationdesc) && t.Qualificationdesc.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult QualificationCreate()
        {
            QualificationCreateViewModel qualificationCreateViewModel = new QualificationCreateViewModel();

            return PartialView("_ModalQualificationCreatePartial", qualificationCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> QualificationCreate([FromForm] QualificationCreateViewModel qualificationCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    QualificationMasterAdd qualificationMasterAdd = new QualificationMasterAdd
                    {
                        PQualificationId = qualificationCreateViewModel.Qualificationid,
                        PQualification = qualificationCreateViewModel.Qualification,
                        PQualificationDesc = qualificationCreateViewModel.Qualificationdesc
                    };

                    var retVal = await _hrmastersRepository.AddQualification(qualificationMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalQualificationCreatePartial", qualificationCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> QualificationEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new QualificationCreateViewModel();

            var qualificationDetail = await _hrmastersViewRepository.QualificationDetail(id);

            if (qualificationDetail == null)
            {
                return NotFound();
            }

            model.Qualificationid = qualificationDetail.Qualificationid;
            model.Qualification = qualificationDetail.Qualification;
            model.Qualificationdesc = qualificationDetail.Qualificationdesc;

            return PartialView("_ModalQualificationUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> QualificationEdit([FromForm] QualificationCreateViewModel qualificationUpdateViewModel)
        {
            var model = new QualificationCreateViewModel();

            try
            {
                var qualificationDetail = await _hrmastersViewRepository.QualificationDetail(qualificationUpdateViewModel.Qualificationid);

                model.Qualificationid = qualificationDetail.Qualificationid;
                model.Qualification = qualificationDetail.Qualification;
                model.Qualificationdesc = qualificationDetail.Qualificationdesc;

                if (ModelState.IsValid)
                {
                    QualificationMasterUpdate qualificationMasterUpdate = new QualificationMasterUpdate
                    {
                        PQualificationId = qualificationUpdateViewModel.Qualificationid,
                        PQualification = qualificationUpdateViewModel.Qualification,
                        PQualificationDesc = qualificationUpdateViewModel.Qualificationdesc
                    };

                    var retVal = await _hrmastersRepository.UpdateQualification(qualificationMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalQualificationUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteQualification(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var qualificationDelete = new QualificationMasterDelete();

                qualificationDelete.PQualificationId = id;

                var retVal = await _hrmastersRepository.DeleteQualification(qualificationDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> QualificationExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersViewRepository.GetQualificationMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "QualificationMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.Worksheet(dt.TableName).Columns().AdjustToContents();
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("QualificationIndex");
        }

        #endregion Qualification master

        #region Graduation master

        public IActionResult GraduationIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetGraduationList(string paramJson)
        {
            DTResult<GraduationMaster> result = new DTResult<GraduationMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetGraduationMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.Graduationid.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.Graduationdesc) && t.Graduationdesc.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult GraduationCreate()
        {
            GraduationCreateViewModel graduationCreateViewModel = new GraduationCreateViewModel();

            return PartialView("_ModalGraduationCreatePartial", graduationCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> GraduationCreate([FromForm] GraduationCreateViewModel graduationCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    GraduationMasterAdd graduationMasterAdd = new GraduationMasterAdd
                    {
                        PGraduationId = graduationCreateViewModel.Graduationid,
                        PGraduationDesc = graduationCreateViewModel.Graduationdesc
                    };

                    var retVal = await _hrmastersRepository.AddGraduation(graduationMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalGraduationCreatePartial", graduationCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> GraduationEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new GraduationCreateViewModel();

            var graduationDetail = await _hrmastersViewRepository.GraduationDetail(id);

            if (graduationDetail == null)
            {
                return NotFound();
            }

            model.Graduationid = graduationDetail.Graduationid;
            model.Graduationdesc = graduationDetail.Graduationdesc;

            return PartialView("_ModalGraduationUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> GraduationEdit([FromForm] GraduationCreateViewModel graduationUpdateViewModel)
        {
            var model = new GraduationCreateViewModel();

            try
            {
                var graduationDetail = await _hrmastersViewRepository.GraduationDetail(graduationUpdateViewModel.Graduationid);

                model.Graduationid = graduationDetail.Graduationid;
                model.Graduationdesc = graduationDetail.Graduationdesc;

                if (ModelState.IsValid)
                {
                    GraduationMasterUpdate graduationMasterUpdate = new GraduationMasterUpdate
                    {
                        PGraduationId = graduationUpdateViewModel.Graduationid,
                        PGraduationDesc = graduationUpdateViewModel.Graduationdesc
                    };

                    var retVal = await _hrmastersRepository.UpdateGraduation(graduationMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalGraduationUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteGraduation(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var graduationDelete = new GraduationMasterDelete();

                graduationDelete.PGraduationId = id;

                var retVal = await _hrmastersRepository.DeleteGraduation(graduationDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> GraduationExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersViewRepository.GetGraduationMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "GraduationMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.Worksheet(dt.TableName).Columns().AdjustToContents();
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("GraduationIndex");
        }

        #endregion Graduation master

        #region Job group master

        public IActionResult JobGroupIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetJobGroupList(string paramJson)
        {
            DTResult<JobGroupMaster> result = new DTResult<JobGroupMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetJobGroupMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.JobGroupCode.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | (!string.IsNullOrWhiteSpace(t.JobGroup) && t.JobGroup.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            | (!string.IsNullOrWhiteSpace(t.MilanJobGroup) && t.MilanJobGroup.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase))
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult JobGroupCreate()
        {
            JobGroupCreateViewModel jobGroupCreateViewModel = new JobGroupCreateViewModel();

            return PartialView("_ModalJobGroupCreatePartial", jobGroupCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> JobGroupCreate([FromForm] JobGroupCreateViewModel jobGroupCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    JobGroupMasterAdd jobGroupMasterAdd = new JobGroupMasterAdd
                    {
                        PGrpCd = jobGroupCreateViewModel.GrpCd,
                        PGrpName = jobGroupCreateViewModel.GrpName,
                        PGrpMilan = jobGroupCreateViewModel.MilanGrpName
                    };

                    var retVal = await _hrmastersRepository.AddJobGroup(jobGroupMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalJobGroupCreatePartial", jobGroupCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> JobGroupEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new JobGroupCreateViewModel();

            var jobGroupDetail = await _hrmastersViewRepository.JobGroupDetail(id);

            if (jobGroupDetail == null)
            {
                return NotFound();
            }

            model.GrpCd = jobGroupDetail.JobGroupCode;
            model.GrpName = jobGroupDetail.JobGroup;
            model.MilanGrpName = jobGroupDetail.MilanJobGroup;

            return PartialView("_ModalJobGroupUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> JobGroupEdit([FromForm] JobGroupCreateViewModel jobGroupUpdateViewModel)
        {
            var model = new JobGroupCreateViewModel();

            try
            {
                var jobGroupDetail = await _hrmastersViewRepository.JobGroupDetail(jobGroupUpdateViewModel.GrpCd);

                model.GrpCd = jobGroupDetail.JobGroupCode;
                model.GrpName = jobGroupDetail.JobGroup;
                model.MilanGrpName = jobGroupDetail.MilanJobGroup;

                if (ModelState.IsValid)
                {
                    JobGroupMasterUpdate jobGroupMasterUpdate = new JobGroupMasterUpdate
                    {
                        PGrpCd = jobGroupUpdateViewModel.GrpCd,
                        PGrpName = jobGroupUpdateViewModel.GrpName,
                        PGrpMilan = jobGroupUpdateViewModel.MilanGrpName
                    };

                    var retVal = await _hrmastersRepository.UpdateJobGroup(jobGroupMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalJobGroupUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteJobGroup(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var jobGroupDelete = new JobGroupMasterDelete();

                jobGroupDelete.PGrpCd = id;

                var retVal = await _hrmastersRepository.DeleteJobGroup(jobGroupDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> JobGroupExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersViewRepository.GetJobGroupMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "JobGroupMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.Worksheet(dt.TableName).Columns().AdjustToContents();
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("JobGroupIndex");
        }

        #endregion Job group master

        #region Job discipline master

        public IActionResult JobDisciplineIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetJobDisciplineList(string paramJson)
        {
            DTResult<JobDisciplineMaster> result = new DTResult<JobDisciplineMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetJobDisciplineMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (t.JobdisciplineCode.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | !string.IsNullOrWhiteSpace(t.Jobdiscipline) && t.Jobdiscipline.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult JobDisciplineCreate()
        {
            JobDisciplineCreateViewModel jobDisciplineCreateViewModel = new JobDisciplineCreateViewModel();

            return PartialView("_ModalJobDisciplineCreatePartial", jobDisciplineCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> JobDisciplineCreate([FromForm] JobDisciplineCreateViewModel jobDisciplineCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    JobDisciplineMasterAdd jobDisciplineMasterAdd = new JobDisciplineMasterAdd
                    {
                        PDisCd = jobDisciplineCreateViewModel.JobdisciplineCode,
                        PDisName = jobDisciplineCreateViewModel.Jobdiscipline
                    };

                    var retVal = await _hrmastersRepository.AddJobDiscipline(jobDisciplineMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalJobDisciplineCreatePartial", jobDisciplineCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> JobDisciplineEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new JobDisciplineCreateViewModel();

            var jobDisciplineDetail = await _hrmastersViewRepository.JobDisciplineDetail(id);

            if (jobDisciplineDetail == null)
            {
                return NotFound();
            }

            model.JobdisciplineCode = jobDisciplineDetail.JobdisciplineCode;
            model.Jobdiscipline = jobDisciplineDetail.Jobdiscipline;

            return PartialView("_ModalJobDisciplineUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> JobDisciplineEdit([FromForm] JobDisciplineCreateViewModel jobDisciplineUpdateViewModel)
        {
            var model = new JobDisciplineCreateViewModel();

            try
            {
                var jobDisciplineDetail = await _hrmastersViewRepository.JobDisciplineDetail(jobDisciplineUpdateViewModel.JobdisciplineCode);

                model.JobdisciplineCode = jobDisciplineDetail.JobdisciplineCode;
                model.Jobdiscipline = jobDisciplineDetail.Jobdiscipline;

                if (ModelState.IsValid)
                {
                    JobDisciplineMasterUpdate jobDisciplineMasterUpdate = new JobDisciplineMasterUpdate
                    {
                        PDisCd = jobDisciplineUpdateViewModel.JobdisciplineCode,
                        PDisName = jobDisciplineUpdateViewModel.Jobdiscipline
                    };

                    var retVal = await _hrmastersRepository.UpdateJobDiscipline(jobDisciplineMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalJobDisciplineUpdatePartial", model);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteJobDiscipline(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var jobDisciplineDelete = new JobDisciplineMasterDelete();

                jobDisciplineDelete.PDisCd = id;

                var retVal = await _hrmastersRepository.DeleteJobDiscipline(jobDisciplineDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> JobDisciplineExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersViewRepository.GetJobDisciplineMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "JobDisciplineMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.Worksheet(dt.TableName).Columns().AdjustToContents();
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("JobDisciplineIndex");
        }

        #endregion Job discipline master

        #region Job title master

        public IActionResult JobTitleIndex()
        {
            return View();
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetJobTitleList(string paramJson)
        {
            DTResult<JobTitleMaster> result = new DTResult<JobTitleMaster>();

            var param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            var data = (await _hrmastersViewRepository.GetJobTitleMasterListAsync()).ToList().AsQueryable();

            // Filtering
            if (!string.IsNullOrEmpty(param.GenericSearch))
            {
                data = data
                        .Where(
                        t => (!string.IsNullOrWhiteSpace(t.JobtitleCode) && t.JobtitleCode.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            | !string.IsNullOrWhiteSpace(t.Jobtitle) && t.Jobtitle.Trim().ToLower().Contains(param.GenericSearch.Trim().ToLower(), StringComparison.InvariantCultureIgnoreCase)
                            )
                         );
            }

            result.draw = param.Draw;
            result.recordsTotal = data.Count();
            result.recordsFiltered = data.Count();
            result.data = data.Skip(param.Start).Take(param.Length).AsNoTracking().ToList();

            return Json(result);
        }

        [HttpGet]
        public IActionResult JobTitleCreate()
        {
            JobTitleCreateViewModel jobTitleCreateViewModel = new JobTitleCreateViewModel();

            return PartialView("_ModalJobTitleCreatePartial", jobTitleCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> JobTitleCreate([FromForm] JobTitleCreateViewModel jobTitleCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    JobTitleMasterAdd jobTitleMasterAdd = new JobTitleMasterAdd
                    {
                        PTitCd = jobTitleCreateViewModel.JobtitleCode,
                        PTitle = jobTitleCreateViewModel.Jobtitle
                    };

                    var retVal = await _hrmastersRepository.AddJobTitle(jobTitleMasterAdd);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalJobTitleCreatePartial", jobTitleCreateViewModel);
            }

            return Json(new { });
        }

        [HttpGet]
        public async Task<IActionResult> JobTitleEdit(string id)
        {
            if (id == null)
                return NotFound();

            var model = new JobTitleCreateViewModel();

            var jobTitleDetail = await _hrmastersViewRepository.JobTitleDetail(id);

            if (jobTitleDetail == null)
            {
                return NotFound();
            }

            model.JobtitleCode = jobTitleDetail.JobtitleCode;
            model.Jobtitle = jobTitleDetail.Jobtitle;

            return PartialView("_ModalJobTitleUpdatePartial", model);
        }

        [HttpPost]
        public async Task<IActionResult> JobTitleEdit([FromForm] JobTitleCreateViewModel jobTitleUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    JobTitleMasterUpdate jobTitleMasterUpdate = new JobTitleMasterUpdate
                    {
                        PTitCd = jobTitleUpdateViewModel.JobtitleCode,
                        PTitle = jobTitleUpdateViewModel.Jobtitle
                    };

                    var retVal = await _hrmastersRepository.UpdateJobTitle(jobTitleMasterUpdate);

                    if (retVal.OutPSuccess == "OK")
                    {
                        Notify("Success", retVal.OutPMessage, "toaster", NotificationType.success);
                    }
                    else
                    {
                        Notify("Error", retVal.OutPMessage, "toaster", NotificationType.error);
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return PartialView("_ModalJobTitleUpdatePartial", jobTitleUpdateViewModel);
            }

            return Json(new { });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteJobTitle(string id)
        {
            if (id == null)
                return NotFound();

            try
            {
                var jobTitleDelete = new JobTitleMasterDelete();

                jobTitleDelete.PTitCd = id;

                var retVal = await _hrmastersRepository.DeleteJobTitle(jobTitleDelete);

                return Json(new { Success = retVal.OutPSuccess == "OK", Message = retVal.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, HRMastersHelper.ActionEditEmplmast)]
        public async Task<IActionResult> JobTitleExcelDownload()
        {
            try
            {
                DataTable dt = new DataTable();
                string strUser = User.Identity.Name;
                var result = (await _hrmastersViewRepository.GetJobTitleMasterDownload()).ToList();

                if (result == null)
                {
                    return NotFound();
                }

                ListtoDataTableConverter converter = new ListtoDataTableConverter();
                dt = converter.ToDataTable(result);
                var timeStamp = DateTime.Now.ToFileTime();
                string StrFimeName = "JobTitleMasterDownload_" + timeStamp.ToString();
                using (XLWorkbook wb = new XLWorkbook())
                {
                    wb.Worksheets.Add(dt);
                    using (MemoryStream stream = new MemoryStream())
                    {
                        wb.Worksheet(dt.TableName).Columns().AdjustToContents();
                        wb.SaveAs(stream);
                        stream.Position = 0;
                        return File(stream.ToArray(),
                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                   StrFimeName + ".xlsx");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message, "toaster", notificationType: NotificationType.error);
            }
            return RedirectToAction("JobTitleIndex");
        }

        #endregion Job title master
    }
}