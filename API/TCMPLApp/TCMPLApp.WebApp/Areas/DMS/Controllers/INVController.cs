using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using MimeTypes;
using MoreLinq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models.Common;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;
using TCMPLApp.WebApp.Classes;
using TCMPLApp.WebApp.Controllers;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Models;
using static TCMPLApp.WebApp.Classes.DTModel;
using Table = DocumentFormat.OpenXml.Wordprocessing.Table;

namespace TCMPLApp.WebApp.Areas.DMS.Controllers
{
    [Authorize]
    [Area("DMS")]
    public class INVController : BaseController
    {
        private const string ConstFilterItemTypesIndex = "InvItemTypesIndex";
        private const string ConstFilterItemCategoryIndex = "InvItemCategoryIndex";
        private const string ConstFilterItemAsgmtTypesIndex = "InvItemAsgmtTypesIndex";
        private const string ConstFilterItemAMSAssetMappingIndex = "InvItemAMSAssetMappingIndex";
        private const string ConstFilterInvAddOnContainerIndex = "InvAddOnContainerIndex";
        private const string ConstFilterLaptopLotWiseIndex = "LaptopLotWiseIndex";

        private const string ConstFilterTransactionIndex = "InvTransactionIndex";
        private const string ConstFilterTransactionDetailIndex = "InvTransactionDetailIndex";

        private const string ConstFilterConsumablesDetailIndex = "InvConsumablesDetailIndex";
        private const string ConstFilterConsumablesIndex = "InvConsumablesIndex";

        private const string ConstFilterGroupDetailIndex = "InvGroupDetailIndex";
        private const string ConstFilterGroupsIndex = "InvGroupsIndex";
        private const string ConstFilterReserveItemsIndex = "ReserveItemsIndex";

        private const string ConstPTransTypeIdReserve = "T01";
        private const string ConstPTransTypeIdIssue = "T03";
        private const string ConstPTransTypeIdReceive = "T04";

        private const string ConstFilterItemAddOnIndex = "InvItemAddOnIndex";

        private const string ConstFilterEmployeeTransactionIndex = "InvEmployeeTransactionIndex";
        private const string ConstFilterEmployeeTransactionDetailIndex = "InvEmployeeTransactionDetailIndex";
        private const string ConstFilterEmployeeTransactionReservedIndex = "InvEmployeeTransactionReservedIndex";
        private const string ConstFilterEmployeeTransactionHistoryIndex = "InvEmployeeTransactionHistoryIndex";
        private const string ConstFilterItemNotInServiceIndex = "ItemNotInServiceIndex";

        private readonly IConfiguration _configuration;

        private readonly IDMSEmployeeRepository _dmsEmployeeRepository;

        private readonly ISelectTcmPLRepository _selectTcmPLRepository;
        private readonly IFilterRepository _filterRepository;
        private readonly IUtilityRepository _utilityRepository;

        private readonly IInvItemAsgmtTypesDataTableListRepository _invItemAsgmtTypesDataTableListRepository;
        private readonly IInvItemAsgmtTypesDetailRepository _invItemAsgmtTypesDetailRepository;
        private readonly IInvItemAsgmtTypesRepository _invItemAsgmtTypesRepository;

        private readonly IInvItemTypesDataTableListRepository _invItemTypesDataTableListRepository;
        private readonly IInvItemTypesDetailRepository _invItemTypesDetailRepository;
        private readonly IInvItemTypesRepository _itemTypesRepository;

        private readonly IInvItemCategoryRepository _invItemCategoryRepository;
        private readonly IInvItemCategoryDetailRepository _invItemCategoryDetailRepository;
        private readonly IInvItemCategoryDataTableListRepository _invItemCategoryDataTableListRepository;

        private readonly IInvItemAMSAssetMappingRepository _invItemAMSAssetMappingRepository;
        private readonly IInvItemAMSAssetMappingDetailRepository _invItemAMSAssetMappingDetailRepository;
        private readonly IInvItemAMSAssetMappingDataTableListRepository _invItemAMSAssetMappingDataTableListRepository;

        private readonly IInvTransactionDataTableListRepository _invTransactionDataTableListRepository;
        private readonly IInvTransactionDataTableListExcelRepository _invTransactionDataTableListExcelRepository;
        private readonly IInvTransactionDetailDataTableListRepository _invTransactionDetailDataTableListRepository;

        private readonly IInvConsumablesDataTableListRepository _invConsumablesDataTableListRepository;
        private readonly IInvConsumablesDetailsRepository _invConsumablesDetailsRepository;
        private readonly IInvConsumablesDetailDataTableListRepository _invConsumablesDetailDataTableListRepository;

        private readonly IInvConsumablesImportRepository _invConsumablesImportRepository;

        private readonly IInvItemGroupDataTableListRepository _invItemGroupDataTableListRepository;
        private readonly IInvItemGroupDetailRepository _invItemGroupDetailRepository;
        private readonly IInvItemGroupDetailDataTableListRepository _invItemGroupDetailDataTableListRepository;
        private readonly IInvItemGroupImportRepository _invItemGroupImportRepository;
        private readonly IInvItemGroupRepository _invItemGroupRepository;

        private readonly IInvTransactionRepository _invTransactionRepository;
        private readonly IInvTransactionForIdRepository _invTransactionForIdRepository;
        private readonly IInvTransactionDetailsRepository _invTransactionDetailsRepository;

        private readonly IInvItemAddOnTransRepository _invItemAddOnTransRepository;
        private readonly IInvItemAddOnDataTableListRepository _invItemAddOnDataTableListRepository;

        private readonly IInvAddOnContainerDataTableListRepository _invAddOnContainerDataTableListRepository;
        private readonly IInvAddOnContainerRepository _invAddOnContainerRepository;

        private readonly IExcelTemplate _excelTemplate;

        private readonly IInvEmployeeTransactionDataTableListRepository _invEmployeeTransactionDataTableListRepository;
        private readonly IInvEmployeeTransactionDetailDataTableListRepository _invEmployeeTransactionDetailDataTableListRepository;
        private readonly IInvEmployeeDetailsRepository _invEmployeeDetailsRepository;

        private readonly ILaptopLotWiseDataTableListRepository _laptopLotWiseDataTableListRepository;
        private readonly IInvLaptopLotwiseDataTableListExcelRepository _invLaptopLotwiseDataTableListExcelRepository;
        private readonly IInvItemNotInServiceDataTableListRepository _invItemNotInServiceDataTableListRepository;
        private readonly IInvReserveItemsDetailsRepository _invReserveItemsDetailsRepository;

        public INVController(
            IConfiguration configuration,
            IDMSEmployeeRepository dmsEmployeeRepository,
            IFilterRepository filterRepository,
            ISelectTcmPLRepository selectTcmPLRepository,
            IInvItemTypesDataTableListRepository invItemTypesDataTableListRepository,
            IInvItemTypesDetailRepository invItemTypesDetailRepository,
            IInvItemTypesRepository itemTypesRepository,
            IInvItemCategoryRepository invItemCategoryRepository,
            IInvItemCategoryDetailRepository invItemCategoryDetailRepository,
            IInvItemCategoryDataTableListRepository invItemCategoryDataTableListRepository,
            IInvItemAsgmtTypesDataTableListRepository invItemAsgmtTypesDataTableListRepository,
            IInvItemAsgmtTypesDetailRepository invItemAsgmtTypesDetailRepository,
            IInvItemAsgmtTypesRepository invItemAsgmtTypesRepository,
            IInvItemAMSAssetMappingRepository invItemAMSAssetMappingRepository,
            IInvItemAMSAssetMappingDetailRepository invItemAMSAssetMappingDetailRepository,
            IInvItemAMSAssetMappingDataTableListRepository invItemAMSAssetMappingDataTableListRepository,
            IInvTransactionDataTableListRepository invTransactionDataTableListRepository,
            IInvTransactionDataTableListExcelRepository invTransactionDataTableListExcelRepository,
            IInvTransactionDetailDataTableListRepository invTransactionDetailDataTableListRepository,
            IInvTransactionRepository invTransactionRepository,
            IInvTransactionForIdRepository invTransactionForIdRepository,
            IInvTransactionDetailsRepository invTransactionDetailsRepository,

            IInvItemAddOnTransRepository invItemAddOnTransRepository,
            IInvItemAddOnDataTableListRepository invItemAddOnDataTableListRepository,

            IInvConsumablesDataTableListRepository invConsumablesDataTableListRepository,
            IInvConsumablesImportRepository invConsumablesImportRepository,
            IInvConsumablesDetailDataTableListRepository invConsumablesDetailDataTableListRepository,
            IInvConsumablesDetailsRepository invConsumablesDetailsRepository,

            IInvItemGroupDataTableListRepository invItemGroupDataTableListRepository,
            IInvItemGroupImportRepository invItemGroupImportRepository,
            IInvItemGroupDetailDataTableListRepository invItemGroupDetailDataTableListRepository,
            IInvItemGroupDetailRepository invItemGroupDetailsRepository,

            IExcelTemplate excelTemplate,

            IUtilityRepository utilityRepository,
            IInvAddOnContainerDataTableListRepository invAddOnContainerDataTableListRepository,
            IInvAddOnContainerRepository invAddOnContainerRepository,

            IInvEmployeeTransactionDataTableListRepository invEmployeeTransactionDataTableListRepository,
            IInvEmployeeTransactionDetailDataTableListRepository invEmployeeTransactionDetailDataTableListRepository,
            IInvEmployeeDetailsRepository invEmployeeDetailsRepository,
            ILaptopLotWiseDataTableListRepository laptopLotWiseDataTableListRepository,
            IInvLaptopLotwiseDataTableListExcelRepository invLaptopLotwiseDataTableListExcelRepository,
            IInvItemNotInServiceDataTableListRepository invItemNotInServiceDataTableListRepository,
            IInvItemGroupRepository invItemGroupRepository,
            IInvReserveItemsDetailsRepository invReserveItemsDetailsRepository
            )
        {
            _configuration = configuration;
            _dmsEmployeeRepository = dmsEmployeeRepository;
            _filterRepository = filterRepository;
            _selectTcmPLRepository = selectTcmPLRepository;
            _invItemTypesDataTableListRepository = invItemTypesDataTableListRepository;
            _invItemTypesDetailRepository = invItemTypesDetailRepository;
            _itemTypesRepository = itemTypesRepository;

            _invItemCategoryRepository = invItemCategoryRepository;
            _invItemCategoryDetailRepository = invItemCategoryDetailRepository;
            _invItemCategoryDataTableListRepository = invItemCategoryDataTableListRepository;

            _invItemAsgmtTypesDataTableListRepository = invItemAsgmtTypesDataTableListRepository;
            _invItemAsgmtTypesDetailRepository = invItemAsgmtTypesDetailRepository;
            _invItemAsgmtTypesRepository = invItemAsgmtTypesRepository;

            _invItemAMSAssetMappingRepository = invItemAMSAssetMappingRepository;
            _invItemAMSAssetMappingDetailRepository = invItemAMSAssetMappingDetailRepository;
            _invItemAMSAssetMappingDataTableListRepository = invItemAMSAssetMappingDataTableListRepository;

            _invTransactionDataTableListRepository = invTransactionDataTableListRepository;
            _invTransactionDataTableListExcelRepository = invTransactionDataTableListExcelRepository;
            _invTransactionDetailDataTableListRepository = invTransactionDetailDataTableListRepository;
            _invTransactionRepository = invTransactionRepository;
            _invTransactionForIdRepository = invTransactionForIdRepository;
            _invTransactionDetailsRepository = invTransactionDetailsRepository;

            _invItemAddOnTransRepository = invItemAddOnTransRepository;
            _invItemAddOnDataTableListRepository = invItemAddOnDataTableListRepository;

            _invConsumablesDataTableListRepository = invConsumablesDataTableListRepository;
            _invConsumablesImportRepository = invConsumablesImportRepository;
            _invConsumablesDetailDataTableListRepository = invConsumablesDetailDataTableListRepository;

            _invConsumablesDetailsRepository = invConsumablesDetailsRepository;

            _invItemGroupDataTableListRepository = invItemGroupDataTableListRepository;
            _invItemGroupImportRepository = invItemGroupImportRepository;
            _invItemGroupDetailDataTableListRepository = invItemGroupDetailDataTableListRepository;

            _invItemGroupDetailRepository = invItemGroupDetailsRepository;

            _excelTemplate = excelTemplate;

            _utilityRepository = utilityRepository;
            _invAddOnContainerDataTableListRepository = invAddOnContainerDataTableListRepository;
            _invAddOnContainerRepository = invAddOnContainerRepository;

            _invEmployeeTransactionDataTableListRepository = invEmployeeTransactionDataTableListRepository;
            _invEmployeeTransactionDetailDataTableListRepository = invEmployeeTransactionDetailDataTableListRepository;
            _invEmployeeDetailsRepository = invEmployeeDetailsRepository;
            _laptopLotWiseDataTableListRepository = laptopLotWiseDataTableListRepository;
            _invLaptopLotwiseDataTableListExcelRepository = invLaptopLotwiseDataTableListExcelRepository;
            _invItemNotInServiceDataTableListRepository = invItemNotInServiceDataTableListRepository;
            _invItemGroupRepository = invItemGroupRepository;
            _invReserveItemsDetailsRepository = invReserveItemsDetailsRepository;
        }

        public async Task<IActionResult> Index()
        {
            ReserveItemDetailOut details = await _invReserveItemsDetailsRepository.ReserveItemsDetailsAsync(
                           BaseSpTcmPLGet(), new ParameterSpTcmPL());
            ViewData["ReturnItemCount"] = details.PReserveItemCount;
            return View();
        }

        #region InvItemTypesIndex

        public async Task<IActionResult> InvItemTypesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterItemTypesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemTypesViewModel invItemTypesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invItemTypesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsInvItemTypes(DTParameters param)
        {
            DTResult<InvItemTypesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvItemTypesDataTableList> data = await _invItemTypesDataTableListRepository.InvItemTypesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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
        public async Task<IActionResult> InvItemTypesCreate()
        {
            InvItemTypesCreateViewModel deskInvItemTypesCreateViewModel = new();

            var categoryCodeList = await _selectTcmPLRepository.InvItemCategoryList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var itemAssignmentTypeList = await _selectTcmPLRepository.InvItemAsgmtTypesFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var dmsItemIssueAction = _selectTcmPLRepository.GetListDmsItemIssueAction();
            ViewData["DmsItemIssueActionList"] = new SelectList(dmsItemIssueAction, "DataValueField", "DataTextField");

            ViewData["CategoryCodeList"] = new SelectList(categoryCodeList, "DataValueField", "DataTextField");
            ViewData["ItemAssignmentTypeList"] = new SelectList(itemAssignmentTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvItemTypesCreatePartial", deskInvItemTypesCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemTypesCreate([FromForm] InvItemTypesCreateViewModel itemTypesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _itemTypesRepository.ItemTypesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PItemTypeCode = itemTypesCreateViewModel.ItemTypeCode,
                            PCategoryCode = itemTypesCreateViewModel.CategoryCode,
                            PItemAssignmentType = itemTypesCreateViewModel.ItemAssignmentType,
                            PDescription = itemTypesCreateViewModel.ItemTypeDescription,
                            PPrintOrder = itemTypesCreateViewModel.PrintOrder,
                            PActionId = itemTypesCreateViewModel.ActionId
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

            var categoryCodeList = await _selectTcmPLRepository.InvItemCategoryList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var itemAssignmentTypeList = await _selectTcmPLRepository.InvItemAsgmtTypesFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            
            var dmsItemIssueAction = _selectTcmPLRepository.GetListDmsItemIssueAction();
            ViewData["DmsItemIssueActionList"] = new SelectList(dmsItemIssueAction, "DataValueField", "DataTextField");

            ViewData["CategoryCodeList"] = new SelectList(categoryCodeList, "DataValueField", "DataTextField");
            ViewData["ItemAssignmentTypeList"] = new SelectList(itemAssignmentTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvItemTypesCreatePartial", itemTypesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> InvItemTypesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            InvItemTypesDetails result = await _invItemTypesDetailRepository.ItemTypesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            InvItemTypesUpdateViewModel itemTypesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                itemTypesUpdateViewModel.ItemTypeKeyId = id;
                itemTypesUpdateViewModel.CategoryCode = result.PCategoryCode;
                itemTypesUpdateViewModel.ItemAssignmentType = result.PItemAssignmentType;

                itemTypesUpdateViewModel.ItemTypeCode = result.PItemTypeCode;
                itemTypesUpdateViewModel.ItemTypeDescription = result.PItemTypeDesc;
                itemTypesUpdateViewModel.PrintOrder = result.PPrintOrder;
                itemTypesUpdateViewModel.ActionId = result.PActionId;
            }

            var categoryCodeList = await _selectTcmPLRepository.InvItemCategoryList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var itemAssignmentTypeList = await _selectTcmPLRepository.InvItemAsgmtTypesFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            var dmsItemIssueAction = _selectTcmPLRepository.GetListDmsItemIssueAction();
            ViewData["DmsItemIssueActionList"] = new SelectList(dmsItemIssueAction, "DataValueField", "DataTextField", itemTypesUpdateViewModel.ActionId);
            ViewData["CategoryCodeList"] = new SelectList(categoryCodeList, "DataValueField", "DataTextField", itemTypesUpdateViewModel.CategoryCode);
            ViewData["ItemAssignmentTypeList"] = new SelectList(itemAssignmentTypeList, "DataValueField", "DataTextField", itemTypesUpdateViewModel.ItemAssignmentType);

            return PartialView("_ModalInvItemTypesEditPartial", itemTypesUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemTypesEdit([FromForm] InvItemTypesUpdateViewModel itemTypesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _itemTypesRepository.ItemTypesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = itemTypesUpdateViewModel.ItemTypeKeyId,
                            PItemTypeCode = itemTypesUpdateViewModel.ItemTypeCode,
                            PCategoryCode = itemTypesUpdateViewModel.CategoryCode,
                            PItemAssignmentType = itemTypesUpdateViewModel.ItemAssignmentType,
                            PDescription = itemTypesUpdateViewModel.ItemTypeDescription,
                            PPrintOrder = itemTypesUpdateViewModel.PrintOrder,
                            PActionId = itemTypesUpdateViewModel.ActionId
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

            var categoryCodeList = await _selectTcmPLRepository.InvItemCategoryList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var itemAssignmentTypeList = await _selectTcmPLRepository.InvItemAsgmtTypesFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });
            var dmsItemIssueAction = _selectTcmPLRepository.GetListDmsItemIssueAction();
            ViewData["DmsItemIssueActionList"] = new SelectList(dmsItemIssueAction, "DataValueField", "DataTextField", itemTypesUpdateViewModel.ActionId);
            ViewData["CategoryCodeList"] = new SelectList(categoryCodeList, "DataValueField", "DataTextField", itemTypesUpdateViewModel.CategoryCode);
            ViewData["ItemAssignmentTypeList"] = new SelectList(itemAssignmentTypeList, "DataValueField", "DataTextField", itemTypesUpdateViewModel.ItemAssignmentType);

            return PartialView("_ModalInvItemTypesEditPartial", itemTypesUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> InvItemTypesDelete(string id)
        {
            try
            {
                var result = await _itemTypesRepository.ItemTypesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> InvItemTypesActivate(string id)
        {
            try
            {
                var result = await _itemTypesRepository.ItemTypesActiveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> InvItemTypesExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterItemTypesIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "InvItemTypes_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<InvItemTypesDataTableList> data = await _invItemTypesDataTableListRepository.InvItemTypesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<InvItemTypesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<InvItemTypesDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "InvItemTypess", "InvItemTypess");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion InvItemTypesIndex

        #region InvItemCategoryIndex

        public async Task<IActionResult> InvItemCategoryIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterItemCategoryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemCategoryViewModel invItemCategoryViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invItemCategoryViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsInvItemCategory(DTParameters param)
        {
            DTResult<InvItemCategoryDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvItemCategoryDataTableList> data = await _invItemCategoryDataTableListRepository.InvItemCategoryDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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
        public IActionResult InvItemCategoryCreate()
        {
            InvItemCategoryCreateViewModel deskInvItemCategoryCreateViewModel = new();

            return PartialView("_ModalInvItemCategoryCreatePartial", deskInvItemCategoryCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemCategoryCreate([FromForm] InvItemCategoryCreateViewModel itemCategoryCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invItemCategoryRepository.ItemCategoryCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCategoryCode = itemCategoryCreateViewModel.CategoryCode,
                            PDescription = itemCategoryCreateViewModel.CategoryDescription
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

            return PartialView("_ModalInvItemCategoryCreatePartial", itemCategoryCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> InvItemCategoryEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            InvItemCategoryDetails result = await _invItemCategoryDetailRepository.ItemCategoryDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            InvItemCategoryUpdateViewModel itemCategoryUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                itemCategoryUpdateViewModel.CategoryCode = id;
                itemCategoryUpdateViewModel.CategoryDescription = result.PItemCategoryDesc;
            }

            return PartialView("_ModalInvItemCategoryEditPartial", itemCategoryUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemCategoryEdit([FromForm] InvItemCategoryUpdateViewModel itemCategoryUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invItemCategoryRepository.ItemCategoryEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PCategoryCode = itemCategoryUpdateViewModel.CategoryCode,
                            PDescription = itemCategoryUpdateViewModel.CategoryDescription
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

            return PartialView("_ModalInvItemCategoryEditPartial", itemCategoryUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> InvItemCategoryDelete(string id)
        {
            try
            {
                var result = await _invItemCategoryRepository.ItemCategoryDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCategoryCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> InvItemCategoryActivate(string id)
        {
            try
            {
                var result = await _invItemCategoryRepository.ItemCategoryActiveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PCategoryCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> InvItemCategoryExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterItemCategoryIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "InvItemCategory_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<InvItemCategoryDataTableList> data = await _invItemCategoryDataTableListRepository.InvItemCategoryDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<InvItemCategoryDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<InvItemCategoryDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "InvItemCategorys", "InvItemCategorys");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion InvItemCategoryIndex

        #region InvItemAsgmtTypesIndex

        public async Task<IActionResult> InvItemAsgmtTypesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterItemAsgmtTypesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemAsgmtTypesViewModel invItemAsgmtTypesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invItemAsgmtTypesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsInvItemAsgmtTypes(DTParameters param)
        {
            DTResult<InvItemAsgmtTypesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvItemAsgmtTypesDataTableList> data = await _invItemAsgmtTypesDataTableListRepository.InvItemAsgmtTypesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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
        public IActionResult InvItemAsgmtTypesCreate()
        {
            InvItemAsgmtTypesCreateViewModel deskInvItemAsgmtTypesCreateViewModel = new();

            return PartialView("_ModalInvItemAsgmtTypesCreatePartial", deskInvItemAsgmtTypesCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemAsgmtTypesCreate([FromForm] InvItemAsgmtTypesCreateViewModel itemAsgmtTypesCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invItemAsgmtTypesRepository.ItemAsgmtTypesCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAsgmtCode = itemAsgmtTypesCreateViewModel.ItemAssignmentTypeCode,
                            PDescription = itemAsgmtTypesCreateViewModel.ItemAssignmentTypeDescription
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

            return PartialView("_ModalInvItemAsgmtTypesCreatePartial", itemAsgmtTypesCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> InvItemAsgmtTypesEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            InvItemAsgmtTypesDetails result = await _invItemAsgmtTypesDetailRepository.ItemAsgmtTypesDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            InvItemAsgmtTypesUpdateViewModel itemAsgmtTypesUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                itemAsgmtTypesUpdateViewModel.ItemAssignmentTypeCode = id;
                itemAsgmtTypesUpdateViewModel.ItemAssignmentTypeDescription = result.PItemAsgmtTypesDesc;
            }

            return PartialView("_ModalInvItemAsgmtTypesEditPartial", itemAsgmtTypesUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemAsgmtTypesEdit([FromForm] InvItemAsgmtTypesUpdateViewModel itemAsgmtTypesUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invItemAsgmtTypesRepository.ItemAsgmtTypesEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAsgmtCode = itemAsgmtTypesUpdateViewModel.ItemAssignmentTypeCode,
                            PDescription = itemAsgmtTypesUpdateViewModel.ItemAssignmentTypeDescription
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

            return PartialView("_ModalInvItemAsgmtTypesEditPartial", itemAsgmtTypesUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> InvItemAsgmtTypesDelete(string id)
        {
            try
            {
                var result = await _invItemAsgmtTypesRepository.ItemAsgmtTypesDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAsgmtCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> InvItemAsgmtTypesActivate(string id)
        {
            try
            {
                var result = await _invItemAsgmtTypesRepository.ItemAsgmtTypesActiveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PAsgmtCode = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> InvItemAsgmtTypesExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterItemAsgmtTypesIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "InvItemAsgmtTypes_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<InvItemAsgmtTypesDataTableList> data = await _invItemAsgmtTypesDataTableListRepository.InvItemAsgmtTypesDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<InvItemAsgmtTypesDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<InvItemAsgmtTypesDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "InvItemAsgmtTypess", "InvItemAsgmtTypess");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion InvItemAsgmtTypesIndex

        #region InvItemAMSAssetMappingIndex

        public async Task<IActionResult> InvItemAMSAssetMappingIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterItemAMSAssetMappingIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemAMSAssetMappingViewModel invItemAMSAssetMappingViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invItemAMSAssetMappingViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsInvItemAMSAssetMapping(DTParameters param)
        {
            DTResult<InvItemAMSAssetMappingDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvItemAMSAssetMappingDataTableList> data = await _invItemAMSAssetMappingDataTableListRepository.InvItemAMSAssetMappingDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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
        public async Task<IActionResult> InvItemAMSAssetMappingCreate()
        {
            InvItemAMSAssetMappingCreateViewModel deskInvItemAMSAssetMappingCreateViewModel = new();

            var itemTypeList = await _selectTcmPLRepository.InvItemTypeFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var subAssetTypeList = await _selectTcmPLRepository.InvAmsSubAssetTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ItemTypeList"] = new SelectList(itemTypeList, "DataValueField", "DataTextField");
            ViewData["SubAssetTypeList"] = new SelectList(subAssetTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvItemAMSAssetMappingCreatePartial", deskInvItemAMSAssetMappingCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemAMSAssetMappingCreate([FromForm] InvItemAMSAssetMappingCreateViewModel itemAMSAssetMappingCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invItemAMSAssetMappingRepository.ItemAMSAssetMappingCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PItemTypeKeyId = itemAMSAssetMappingCreateViewModel.ItemType,
                            PSubAssetType = itemAMSAssetMappingCreateViewModel.SubAssetType,
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
            var itemTypeList = await _selectTcmPLRepository.InvItemTypeFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var subAssetTypeList = await _selectTcmPLRepository.InvAmsSubAssetTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ItemTypeList"] = new SelectList(itemTypeList, "DataValueField", "DataTextField", itemAMSAssetMappingCreateViewModel.ItemType);
            ViewData["SubAssetTypeList"] = new SelectList(subAssetTypeList, "DataValueField", "DataTextField", itemAMSAssetMappingCreateViewModel.SubAssetType);

            return PartialView("_ModalInvItemAMSAssetMappingCreatePartial", itemAMSAssetMappingCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> InvItemAMSAssetMappingEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            InvItemAMSAssetMappingDetails result = await _invItemAMSAssetMappingDetailRepository.ItemAMSAssetMappingDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PKeyId = id
                });

            InvItemAMSAssetMappingUpdateViewModel itemAMSAssetMappingUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                itemAMSAssetMappingUpdateViewModel.ItemAMSAssetMappingKeyId = id;
                itemAMSAssetMappingUpdateViewModel.ItemType = result.PItemTypeKeyId;
                itemAMSAssetMappingUpdateViewModel.SubAssetType = result.PSubAssetType;
            }

            var itemTypeList = await _selectTcmPLRepository.InvItemTypeFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var subAssetTypeList = await _selectTcmPLRepository.InvAmsSubAssetTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ItemTypeList"] = new SelectList(itemTypeList, "DataValueField", "DataTextField", itemAMSAssetMappingUpdateViewModel.ItemType);
            ViewData["SubAssetTypeList"] = new SelectList(subAssetTypeList, "DataValueField", "DataTextField", itemAMSAssetMappingUpdateViewModel.SubAssetType);

            return PartialView("_ModalInvItemAMSAssetMappingEditPartial", itemAMSAssetMappingUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemAMSAssetMappingEdit([FromForm] InvItemAMSAssetMappingUpdateViewModel itemAMSAssetMappingUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invItemAMSAssetMappingRepository.ItemAMSAssetMappingEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PKeyId = itemAMSAssetMappingUpdateViewModel.ItemAMSAssetMappingKeyId,
                            PItemTypeKeyId = itemAMSAssetMappingUpdateViewModel.ItemType,
                            PSubAssetType = itemAMSAssetMappingUpdateViewModel.SubAssetType,
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

            var itemTypeList = await _selectTcmPLRepository.InvItemAsgmtTypesFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            var subAssetTypeList = await _selectTcmPLRepository.InvAmsSubAssetTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ItemTypeList"] = new SelectList(itemTypeList, "DataValueField", "DataTextField", itemAMSAssetMappingUpdateViewModel.ItemType);
            ViewData["SubAssetTypeList"] = new SelectList(subAssetTypeList, "DataValueField", "DataTextField", itemAMSAssetMappingUpdateViewModel.SubAssetType);

            return PartialView("_ModalInvItemAMSAssetMappingEditPartial", itemAMSAssetMappingUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> InvItemAMSAssetMappingDelete(string id)
        {
            try
            {
                var result = await _invItemAMSAssetMappingRepository.ItemAMSAssetMappingDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> InvItemAMSAssetMappingActivate(string id)
        {
            try
            {
                var result = await _invItemAMSAssetMappingRepository.ItemAMSAssetMappingActiveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> InvItemAMSAssetMappingExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterItemAMSAssetMappingIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "InvItemAMSAssetMapping_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<InvItemAMSAssetMappingDataTableList> data = await _invItemAMSAssetMappingDataTableListRepository.InvItemAMSAssetMappingDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<InvItemAMSAssetMappingDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<InvItemAMSAssetMappingDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, "InvItemAMSAssetMappings", "InvItemAMSAssetMappings");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion InvItemAMSAssetMappingIndex

        #region InvTransactionIndex

        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionAssetIssue)]
        public async Task<IActionResult> InvTransactionIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTransactionIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvTransactionViewModel invTransactionViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invTransactionViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionAssetIssue)]
        public async Task<JsonResult> GetListsTransaction(DTParameters param)
        {
            DTResult<InvTransactionDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvTransactionDataTableList> data = await _invTransactionDataTableListRepository.TransactionDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionAssetIssue)]
        public async Task<IActionResult> InvTransactionCreate()
        {
            InvTransactionCreateViewModel invTransactionCreateViewModel = new();
            string actionId = null;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionITAssetIssue))
            {
                actionId = DMSHelper.ActionITAssetIssue;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionMobileAssetIssue))
            {
                actionId = DMSHelper.ActionMobileAssetIssue;
            }

            var invTransTypeList = await _selectTcmPLRepository.InvTransTypeCreateList(BaseSpTcmPLGet(), null);
            ViewData["TransTypeIdList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", invTransTypeList.ToList().FirstOrDefault().DataValueField);

            var dmsEmployeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

            var invItemTypeFullList = await _selectTcmPLRepository.InvItemType4TransList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PActionId = actionId
                });
            ViewData["ItemTypeFullList"] = new SelectList(invItemTypeFullList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvTransactionCreatePartial", invTransactionCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionAssetIssue)]
        public async Task<IActionResult> InvTransactionCreate([FromForm] InvTransactionCreateViewModel invTransactionCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invTransactionForIdRepository.TransactionCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTransDate = invTransactionCreateViewModel.TransDate,
                            PEmpno = invTransactionCreateViewModel.Empno,
                            PTransTypeId = invTransactionCreateViewModel.TransTypeId,
                            PRemarks = invTransactionCreateViewModel.Remarks,
                            PItemId = invTransactionCreateViewModel.ItemId,
                            PItemUsable = "U",
                        });

                    Notify(result.PMessageType == BaseController.IsOk ? "Success" : "Error", result.PMessageText, "", result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error);

                    if (result.PMessageType == IsOk)
                    {
                        return RedirectToAction("InvTransactionAdd", new { id = result.PGetTransId });
                    }

                    //return result.PMessageType != Success
                    //    ? throw new Exception(result.PMessageText.Replace("-", " "))
                    //    : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            string actionId = null;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionITAssetIssue))
            {
                actionId = DMSHelper.ActionITAssetIssue;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionMobileAssetIssue))
            {
                actionId = DMSHelper.ActionMobileAssetIssue;
            }

            var invTransTypeList = await _selectTcmPLRepository.InvTransTypeCreateList(BaseSpTcmPLGet(), null);
            ViewData["TransTypeIdList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", invTransTypeList.ToList().FirstOrDefault().DataValueField);

            var dmsEmployeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

            var invItemTypeFullList = await _selectTcmPLRepository.InvItemType4TransList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PActionId = actionId
                });
            ViewData["ItemTypeFullList"] = new SelectList(invItemTypeFullList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvTransactionCreatePartial", invTransactionCreateViewModel);
        }

        [HttpGet]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAssetIssue)]
        public async Task<IActionResult> InvQkTransactionCreate(string id)
        {
            InvTransactionCreateViewModel invTransactionCreateViewModel = new()
            {
                TransDate = DateTime.Now
            };

            string actionId = null;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionITAssetIssue))
            {
                actionId = DMSHelper.ActionITAssetIssue;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionMobileAssetIssue))
            {
                actionId = DMSHelper.ActionMobileAssetIssue;
            }

            var invTransTypeList = await _selectTcmPLRepository.InvTransTypeCreateList(BaseSpTcmPLGet(), null);
            ViewData["TransTypeIdList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", invTransTypeList.ToList().FirstOrDefault().DataValueField);

            var dmsEmployeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

            var invItemTypeFullList = await _selectTcmPLRepository.InvItemType4TransList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PActionId = actionId
                });

            ViewData["ItemTypeFullList"] = new SelectList(invItemTypeFullList, "DataValueField", "DataTextField", id);
            invTransactionCreateViewModel.ItemTypeCode = id;

            if (id != null)
            {
                var itemList = await _selectTcmPLRepository.InvItemList(
               BaseSpTcmPLGet(),
               new ParameterSpTcmPL
               {
                   PItemTypeKeyId = id
               });

                ViewData["ItemList"] = new SelectList(itemList, "DataValueField", "DataTextField", id);
            }

            return PartialView("_ModalInvQkTransactionCreate", invTransactionCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleActionAuthorize(WebApp.Classes.Helper.PolicyNamePrefixAction, DMSHelper.ActionITAssetIssue)]
        public async Task<IActionResult> InvQkTransactionCreate([FromForm] InvTransactionCreateViewModel invTransactionCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DBProcMessageOutput resultIssue = new();

                    var result = await _invTransactionRepository.TransactionQKIssueAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTransDate = invTransactionCreateViewModel.TransDate,
                            PEmpno = invTransactionCreateViewModel.Empno,
                            PTransTypeId = invTransactionCreateViewModel.TransTypeId,
                            PRemarks = invTransactionCreateViewModel.Remarks,
                            PItemId = invTransactionCreateViewModel.ItemId,
                            PItemUsable = "U",
                        });
                    //Notify(result.PMessageType == BaseController.IsOk ? "Success" : "Error", result.PMessageText, "", result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error);

                    //if (result.PMessageType == IsOk)
                    //{
                    //    return RedirectToAction("InvTransactionAdd", new { id = result.PGetTransId });
                    //}

                    return result.PMessageType != IsOk
                        ? throw new Exception(result.PMessageText.Replace("-", " "))
                        : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
            string actionId = null;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionITAssetIssue))
            {
                actionId = DMSHelper.ActionITAssetIssue;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionMobileAssetIssue))
            {
                actionId = DMSHelper.ActionMobileAssetIssue;
            }

            var invTransTypeList = await _selectTcmPLRepository.InvTransTypeCreateList(BaseSpTcmPLGet(), null);
            ViewData["TransTypeIdList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", invTransTypeList.ToList().FirstOrDefault().DataValueField);

            var dmsEmployeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

            var invItemTypeFullList = await _selectTcmPLRepository.InvItemType4TransList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PActionId = actionId
                });
            ViewData["ItemTypeFullList"] = new SelectList(invItemTypeFullList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvQkTransactionCreate", invTransactionCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> InvTransactionReturn()
        {
            InvTransactionReturnViewModel invTransactionReturnViewModel = new();

            var invTransTypeList = await _selectTcmPLRepository.InvTransTypeReturnList(BaseSpTcmPLGet(), null);
            ViewData["TransTypeIdList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField", invTransTypeList.ToList().FirstOrDefault().DataValueField);

            var dmsEmployeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

            var itemUsableTypesList = await _selectTcmPLRepository.DMSItemUsableTypesList(BaseSpTcmPLGet(), null);
            ViewData["ItemUsableTypesList"] = new SelectList(itemUsableTypesList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvTransactionReturnPartial", invTransactionReturnViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvTransactionReturn([FromForm] InvTransactionReturnViewModel invTransactionReturnViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invTransactionForIdRepository.TransactionCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTransDate = invTransactionReturnViewModel.TransDate,
                            PEmpno = invTransactionReturnViewModel.Empno,
                            PTransTypeId = invTransactionReturnViewModel.TransTypeId,
                            PRemarks = invTransactionReturnViewModel.Remarks,
                            PItemId = invTransactionReturnViewModel.ItemId,
                            PItemUsable = invTransactionReturnViewModel.ItemUsable
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

            var invTransTypeList = await _selectTcmPLRepository.InvTransTypeReturnList(BaseSpTcmPLGet(), null);
            ViewData["TransTypeIdList"] = new SelectList(invTransTypeList, "DataValueField", "DataTextField");

            var dmsEmployeeList = await _selectTcmPLRepository.EmployeeListForHRAsync(BaseSpTcmPLGet(), null);
            ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");

            var itemUsableTypesList = await _selectTcmPLRepository.DMSItemUsableTypesList(BaseSpTcmPLGet(), null);
            ViewData["ItemUsableTypesList"] = new SelectList(itemUsableTypesList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvTransactionReturnPartial", invTransactionReturnViewModel);
        }

        public async Task<IActionResult> InvTransactionDetailIndex(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTransactionDetailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvTransactionDetailViewModel invTransactionDetailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            _ = new InvTransactionDetails();
            InvTransactionDetails invTransactionDetails;
            if (!string.IsNullOrEmpty(id))
            {
                invTransactionDetails = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id,
                });
            }
            else
            {
                return View("InvTransactionDetailIndex", invTransactionDetailViewModel);
            }
            //return RedirectToAction("InvTransactionCreate");

            invTransactionDetailViewModel.TransId = id;
            invTransactionDetailViewModel.InvTransactionDetails = invTransactionDetails;

            return View("InvTransactionDetailIndex", invTransactionDetailViewModel);
        }

        public async Task<IActionResult> InvTransactionDetailMain(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTransactionDetailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvTransactionDetailViewModel invTransactionDetailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            var invTransactionDetails = new InvTransactionDetails();
            if (!string.IsNullOrEmpty(id))
            {
                invTransactionDetails = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id,
                });
            }

            invTransactionDetailViewModel.TransId = id;
            invTransactionDetailViewModel.InvTransactionDetails = invTransactionDetails;

            return PartialView("_InvTransactionDetailMainPartial", invTransactionDetailViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> InvTransactionDetailPostIndex(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTransactionDetailIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvTransactionDetailViewModel invTransactionDetailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            InvTransactionDetails invTransactionDetails = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id
                });

            invTransactionDetailViewModel.TransId = id;
            invTransactionDetailViewModel.InvTransactionDetails = invTransactionDetails;

            return View("InvTransactionDetailIndex", invTransactionDetailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsTransactionDetail(DTParameters param)
        {
            DTResult<InvTransactionDetailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvTransactionDetailDataTableList> data = await _invTransactionDetailDataTableListRepository.TransactionDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTransId = param.TransId,
                        PGenericSearch = param.GenericSearch ?? " ",
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
        public async Task<IActionResult> InvTransactionAdd(string id)
        {
            TempData["Message"] = TempData["Message"];

            InvTransactionAddViewModel invTransactionAddViewModel = new();
            string actionId = null;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionITAssetIssue))
            {
                actionId = DMSHelper.ActionITAssetIssue;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionMobileAssetIssue))
            {
                actionId = DMSHelper.ActionMobileAssetIssue;
            }

            var invItemTypeFullList = await _selectTcmPLRepository.InvItemType4TransList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PActionId = actionId
                });
            ViewData["ItemTypeFullList"] = new SelectList(invItemTypeFullList, "DataValueField", "DataTextField");

            InvTransactionDetails invTransactionDetails = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id
                });

            invTransactionAddViewModel.TransId = id;
            invTransactionAddViewModel.Empno = invTransactionDetails.PEmpno + " - " + invTransactionDetails.PEmpName;

            return PartialView("_ModalInvTransactionAddPartial", invTransactionAddViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvTransactionAdd([FromForm] InvTransactionAddViewModel invTransactionAddViewModel)
        {
            if (ModelState.IsValid)
            {
                var result = await _invTransactionForIdRepository.TransactionCreateAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTransId = invTransactionAddViewModel.TransId,
                        PItemId = invTransactionAddViewModel.ItemId,
                        PItemUsable = "U",
                    });

                Notify(result.PMessageType == BaseController.IsOk ? "Success" : "Error", result.PMessageText, "", result.PMessageType == BaseController.IsOk ? NotificationType.success : NotificationType.error);
                if (result.PMessageType == BaseController.IsOk)
                {
                    return base.RedirectToAction("InvTransactionAdd", new { id = invTransactionAddViewModel.TransId });
                }
            }
            var itemIdList = await _selectTcmPLRepository.InvItemList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PItemTypeKeyId = invTransactionAddViewModel.ItemTypeCode
            });
            string actionId = null;

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionITAssetIssue))
            {
                actionId = DMSHelper.ActionITAssetIssue;
            }

            if (CurrentUserIdentity.ProfileActions.Any(p => p.ActionId == DMSHelper.ActionMobileAssetIssue))
            {
                actionId = DMSHelper.ActionMobileAssetIssue;
            }

            ViewData["ItemIdList"] = new SelectList(itemIdList, "DataValueField", "DataTextField", invTransactionAddViewModel.ItemId);
            var invItemTypeFullList = await _selectTcmPLRepository.InvItemType4TransList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PActionId = actionId
                });

            ViewData["ItemTypeFullList"] = new SelectList(invItemTypeFullList, "DataValueField", "DataTextField", invTransactionAddViewModel.ItemTypeCode);

            return PartialView("_ModalInvTransactionAddPartial", invTransactionAddViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> InvTransactionReturnAdd(string id, string parameter)
        {
            InvTransactionReturnAddViewModel invTransactionReturnAddViewModel = new();

            var returnItemList = await _selectTcmPLRepository.InvReturnItemList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = id
                });
            ViewData["ReturnItemList"] = new SelectList(returnItemList, "DataValueField", "DataTextField");

            InvTransactionDetails invTransactionDetails = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = parameter
                });

            invTransactionReturnAddViewModel.TransId = parameter;
            invTransactionReturnAddViewModel.TransTypeId = invTransactionDetails.PTransTypeId;
            invTransactionReturnAddViewModel.Empno = invTransactionDetails.PEmpno;
            invTransactionReturnAddViewModel.EmpName = invTransactionDetails.PEmpno + " - " + invTransactionDetails.PEmpName;

            return PartialView("_ModalInvTransactionReturnAddPartial", invTransactionReturnAddViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvTransactionReturnAdd([FromForm] InvTransactionReturnAddViewModel invTransactionReturnAddViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invTransactionForIdRepository.TransactionCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTransId = invTransactionReturnAddViewModel.TransId,
                            PEmpno = invTransactionReturnAddViewModel.Empno,
                            PTransTypeId = invTransactionReturnAddViewModel.TransTypeId,
                            PItemId = invTransactionReturnAddViewModel.ItemId,
                            PItemUsable = invTransactionReturnAddViewModel.ItemUsable,
                        });
                    return RedirectToAction("InvTransactionReturnAdd", new { id = invTransactionReturnAddViewModel.Empno, parameter = invTransactionReturnAddViewModel.TransId });

                    //return result.PMessageType != Success
                    //    ? throw new Exception(result.PMessageText.Replace("-", " "))
                    //    : (IActionResult)Json(new { success = true, response = result.PMessageText });
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var returnItemList = await _selectTcmPLRepository.InvReturnItemList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = invTransactionReturnAddViewModel.Empno
                });
            ViewData["ReturnItemList"] = new SelectList(returnItemList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvTransactionReturnAddPartial", invTransactionReturnAddViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> InvTransactionIssue(string id)
        {
            //try
            //{
            var result = await _invTransactionRepository.TransactionIssueAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id,
                    PTransTypeId = ConstPTransTypeIdIssue
                }
                );

            return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            //}
            //catch (Exception ex)
            //{
            //    return Json(new { success = false, response = ex.Message });
            //}
        }

        [HttpPost]
        public async Task<IActionResult> InvTransactionDelete(string id)
        {
            try
            {
                var result = await _invTransactionRepository.TransactionDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTransId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> InvTransactionReceive(string id)
        {
            try
            {
                var result = await _invTransactionRepository.TransactionReceiveAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTransId = id,
                        PTransTypeId = ConstPTransTypeIdReceive
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> InvTransactionReserveReturnDelete(string id)
        {
            try
            {
                var result = await _invTransactionRepository.TransactionReserveReturnDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTransId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> InvTransactionEdit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var result = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id
                });

            InvTransactionUpdateViewModel invTransactionUpdateViewModel = new();

            if (result.PMessageType == IsOk)
            {
                invTransactionUpdateViewModel.TransId = id;
                invTransactionUpdateViewModel.TransDate = result.PTransDate;
                invTransactionUpdateViewModel.Empno = result.PEmpno + " " + result.PEmpName;
                invTransactionUpdateViewModel.Remarks = result.PRemarks;
            }

            return PartialView("_ModalInvTransactionEditPartial", invTransactionUpdateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvTransactionEdit([FromForm] InvTransactionUpdateViewModel invTransactionUpdateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invTransactionRepository.TransactionEditAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTransId = invTransactionUpdateViewModel.TransId,
                            PRemarks = invTransactionUpdateViewModel.Remarks
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

            return PartialView("_ModalInvTransactionEditPartial", invTransactionUpdateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> InvTransactionDetailDelete(string id)
        {
            try
            {
                var result = await _invTransactionRepository.TransactionDetailDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTransId = id.Split("!-!")[0],
                        PTransDetId = id.Split("!-!")[1],
                        PTransTypeDesc = id.Split("!-!")[2]
                    });

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> GetItem(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var itemList = await _selectTcmPLRepository.InvItemList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PItemTypeKeyId = id
                });

            return Json(itemList);
        }

        [HttpGet]
        public async Task<IActionResult> GetReturnItem(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var returnItemList = await _selectTcmPLRepository.InvReturnItemList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PEmpno = id
                });

            return Json(returnItemList);
        }

        [HttpGet]
        public async Task<IActionResult> InvTransactionGatePassGenerate(string id)
        {
            try
            {
                string strFileName;
                MemoryStream outputStream = new();

                InvTransactionDetails invTransactionDetails = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id
                });

                if (invTransactionDetails == null)
                {
                    return NotFound();
                }

                System.Collections.Generic.IEnumerable<InvTransactionDetailDataTableList> invTransactionDetailDetails = await _invTransactionDetailDataTableListRepository.TransactionDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTransId = id,
                        PRowNumber = 0,
                        PPageLength = 10000
                    }
                );

                if (invTransactionDetailDetails == null)
                {
                    return NotFound();
                }

                //var baseRepository = _configuration["TCMPLAppBaseRepository"];
                var templateRepository = _configuration["TCMPLAppTemplatesRepository"];
                var areaRepository = _configuration["AreaRepository:DeskManagement"];

                var folder = Path.Combine(templateRepository, areaRepository);
                string docPath = Path.Combine(folder, "LetterTemplate.docx");

                int[,] aryTable1 = new int[,] { { 3, 5 }, { 1, 2 } };
                int[,] aryTab1Val = new int[,] { { 0, 24 }, { 1, 2 } };

                int[,] aryTable2 = new int[,] { { 0, 0, 0 }, { 3, 4, 5 }, { 6, 7, 8 }, { 9, 10, 11 }, { 12, 13, 14 }, { 15, 16, 17 }, { 18, 19, 20 }, { 21, 22, 23 } };

                byte[] templateBytes = System.IO.File.ReadAllBytes(docPath);

                using MemoryStream templateStream = new();
                templateStream.Write(templateBytes, 0, templateBytes.Length);
                using (WordprocessingDocument doc = WordprocessingDocument.Open(templateStream, true))
                {
                    Table table1 = doc.MainDocumentPart.Document.Body.Elements<Table>().First();
                    for (int i = 0; i <= 1; i++)
                    {
                        TableRow row = table1.Elements<TableRow>().ElementAt(i);
                        for (int j = 0; j < aryTable1.GetLength(i); j++)
                        {
                            TableCell cell = row.Elements<TableCell>().ElementAt(aryTable1[i, j]);
                            Paragraph p = cell.Elements<Paragraph>().First();
                            DocumentFormat.OpenXml.Wordprocessing.Run r = p.Elements<DocumentFormat.OpenXml.Wordprocessing.Run>().First();
                            DocumentFormat.OpenXml.Wordprocessing.Text t = r.Elements<DocumentFormat.OpenXml.Wordprocessing.Text>().First();
                            if (i == 0)
                            {
                                if (j == 0)
                                {
                                    t.Text = invTransactionDetails.PGatePassRefNo;
                                }
                                else if (j == 1)
                                {
                                    t.Text = invTransactionDetails.PTransDate?.ToString("dd-MMM-yyyy");
                                }
                            }
                            else if (i == 1)
                            {
                                if (j == 0)
                                {
                                    t.Text = invTransactionDetails.PEmpno + " - " + invTransactionDetails.PEmpName;
                                }
                                else if (j == 1)
                                {
                                    t.Text = "Parent - " + invTransactionDetails.PParent;
                                }
                            }
                        }
                    }

                    Table table2 = doc.MainDocumentPart.Document.Body.Elements<Table>().Last();

                    for (int i = 1; i <= invTransactionDetailDetails.Count(); i++)
                    {
                        TableRow row = table2.Elements<TableRow>().ElementAt(i);
                        if (invTransactionDetailDetails.Count() > 7)
                        {
                            if (i > 6)
                            {
                                TableRow r = (TableRow)row.Clone();
                                _ = table2.AppendChild(r);
                            }
                        }
                        for (int j = 0; j < 3; j++)
                        {
                            TableCell cell = row.Elements<TableCell>().ElementAt(j);
                            Paragraph p = cell.Elements<Paragraph>().First();
                            DocumentFormat.OpenXml.Wordprocessing.Run r = p.Elements<DocumentFormat.OpenXml.Wordprocessing.Run>().First();
                            DocumentFormat.OpenXml.Wordprocessing.Text t = r.Elements<DocumentFormat.OpenXml.Wordprocessing.Text>().First();
                            if (j == 0)
                            {
                                t.Text = invTransactionDetailDetails.ElementAt(i - 1).ItemTypeDescription;
                            }
                            else if (j == 1)
                            {
                                t.Text = invTransactionDetailDetails.ElementAt(i - 1).ItemId;
                            }
                            else if (j == 2)
                            {
                                t.Text = invTransactionDetailDetails.ElementAt(i - 1).ItemDetails;
                            }
                        }
                    }

                    _ = doc.Clone(outputStream);
                }

                strFileName = invTransactionDetails.PGatePassRefNo.ToString() + ".docx";

                return File(outputStream.ToArray(),
                        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                        strFileName);
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> InvTransactionGatePassGenerateAjax(string id)
        {
            try
            {
                string strFileName;
                MemoryStream outputStream = new();

                InvTransactionDetails invTransactionDetails = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id
                });

                if (invTransactionDetails == null)
                {
                    return NotFound();
                }

                System.Collections.Generic.IEnumerable<InvTransactionDetailDataTableList> invTransactionDetailDetails = await _invTransactionDetailDataTableListRepository.TransactionDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PTransId = id,
                        PRowNumber = 0,
                        PPageLength = 10000
                    }
                );

                if (invTransactionDetailDetails == null)
                {
                    return NotFound();
                }

                //var baseRepository = _configuration["TCMPLAppBaseRepository"];
                var templateRepository = _configuration["TCMPLAppTemplatesRepository"];
                var areaRepository = _configuration["AreaRepository:DeskManagement"];
                var folder = Path.Combine(templateRepository, areaRepository);
                string docPath = Path.Combine(folder, "LetterTemplate.docx");

                int[,] aryTable1 = new int[,] { { 3, 5 }, { 1, 2 } };
                int[,] aryTab1Val = new int[,] { { 0, 24 }, { 1, 2 } };

                int[,] aryTable2 = new int[,] { { 0, 0, 0 }, { 3, 4, 5 }, { 6, 7, 8 }, { 9, 10, 11 }, { 12, 13, 14 }, { 15, 16, 17 }, { 18, 19, 20 }, { 21, 22, 23 } };

                byte[] templateBytes = System.IO.File.ReadAllBytes(docPath);

                using MemoryStream templateStream = new();
                templateStream.Write(templateBytes, 0, templateBytes.Length);
                using (WordprocessingDocument doc = WordprocessingDocument.Open(templateStream, true))
                {
                    Table table1 = doc.MainDocumentPart.Document.Body.Elements<Table>().First();
                    for (int i = 0; i <= 1; i++)
                    {
                        TableRow row = table1.Elements<TableRow>().ElementAt(i);
                        for (int j = 0; j < aryTable1.GetLength(i); j++)
                        {
                            TableCell cell = row.Elements<TableCell>().ElementAt(aryTable1[i, j]);
                            Paragraph p = cell.Elements<Paragraph>().First();
                            DocumentFormat.OpenXml.Wordprocessing.Run r = p.Elements<DocumentFormat.OpenXml.Wordprocessing.Run>().First();
                            DocumentFormat.OpenXml.Wordprocessing.Text t = r.Elements<DocumentFormat.OpenXml.Wordprocessing.Text>().First();
                            if (i == 0)
                            {
                                if (j == 0)
                                {
                                    t.Text = invTransactionDetails.PGatePassRefNo;
                                }
                                else if (j == 1)
                                {
                                    t.Text = invTransactionDetails.PTransDate?.ToString("dd-MMM-yyyy");
                                }
                            }
                            else if (i == 1)
                            {
                                if (j == 0)
                                {
                                    t.Text = invTransactionDetails.PEmpno + " - " + invTransactionDetails.PEmpName;
                                }
                                else if (j == 1)
                                {
                                    t.Text = "Parent - " + invTransactionDetails.PParent;
                                }
                            }
                        }
                    }

                    Table table2 = doc.MainDocumentPart.Document.Body.Elements<Table>().Last();

                    for (int i = 1; i <= invTransactionDetailDetails.Count(); i++)
                    {
                        TableRow row = table2.Elements<TableRow>().ElementAt(i);
                        if (invTransactionDetailDetails.Count() > 7)
                        {
                            if (i > 6)
                            {
                                TableRow r = (TableRow)row.Clone();
                                _ = table2.AppendChild(r);
                            }
                        }
                        for (int j = 0; j < 3; j++)
                        {
                            TableCell cell = row.Elements<TableCell>().ElementAt(j);
                            Paragraph p = cell.Elements<Paragraph>().First();
                            DocumentFormat.OpenXml.Wordprocessing.Run r = p.Elements<DocumentFormat.OpenXml.Wordprocessing.Run>().First();
                            DocumentFormat.OpenXml.Wordprocessing.Text t = r.Elements<DocumentFormat.OpenXml.Wordprocessing.Text>().First();
                            if (j == 0)
                            {
                                t.Text = invTransactionDetailDetails.ElementAt(i - 1).ItemTypeDesc;
                            }
                            else if (j == 1)
                            {
                                t.Text = invTransactionDetailDetails.ElementAt(i - 1).ItemId;
                            }
                            else if (j == 2)
                            {
                                t.Text = invTransactionDetailDetails.ElementAt(i - 1).ItemDetails;
                            }
                        }
                    }

                    _ = doc.Clone(outputStream);
                }

                strFileName = invTransactionDetails.PGatePassRefNo.ToString() + ".docx";

                //return File(outputStream.ToArray(),
                //        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                //        strFileName);

                // var byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(outputStream.ToArray(), "Report Title", "Sheet name");

                var byteContent = outputStream.ToArray();

                var mimeType = MimeTypeMap.GetMimeType("docx");

                FileContentResult file = File(byteContent, mimeType, strFileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> InvTransactionExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterTransactionIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                string StrFimeName;

                var timeStamp = DateTime.Now.ToFileTime();
                StrFimeName = "InvTransaction_" + timeStamp.ToString();

                string strUser = User.Identity.Name;

                IEnumerable<InvTransactionDataTableListExcel> data = await _invTransactionDataTableListExcelRepository.TransactionDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null) { return NotFound(); }

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(data, "InvTransactions", "InvTransactions");

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, StrFimeName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        [HttpGet]
        public async Task<IActionResult> ShowInvItemReturnViewModel(string empno, string items)
        {
            InvItemReturnViewModel invItemReturnViewModel = new();

            try
            {
                if (empno is null || empno.Length == 0)
                {
                    return NotFound();
                }
                if (items is null || items.Length == 0)
                {
                    return NotFound();
                }

                List<ReturnItems> returnItemList = new();
                string[] arrItems = items.Split(',');
                foreach (var item in arrItems)
                {
                    if (!string.IsNullOrEmpty(item))
                    {
                        string[] arrRetItems = item.Split("~!~");
                        ReturnItems Item = new()
                        {
                            ItemId = arrRetItems[0].ToString(),
                            IsUsable = arrRetItems[1].ToString()
                        };

                        returnItemList.Add(Item);
                    }
                }
                var jsonString = JsonConvert.SerializeObject(returnItemList);

                var data = await _invEmployeeTransactionDetailDataTableListRepository.
                               EmployeeTransactionDetailDataTableListAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PEmpno = empno,
                            PTransTypeId = ConstPTransTypeIdIssue,
                            PJsonObj = jsonString,
                            PGenericSearch = " ",
                            PRowNumber = 0,
                            PPageLength = 9999
                        }
                    );
                invItemReturnViewModel.Empno = empno;

                string[] aryItem = items.Split(",");

                invItemReturnViewModel.JSonObject = items;
                invItemReturnViewModel.ItemList = data;
                return PartialView("_ModalInvItemRetrun", invItemReturnViewModel);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SubmitReturn(InvItemReturnViewModel invItemReturnViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    ReturnJson returnJson = new();
                    List<ReturnItems> returnItemList = new();

                    returnJson.Empno = invItemReturnViewModel.Empno;
                    returnJson.TransDate = invItemReturnViewModel.TransactionDate;
                    returnJson.TransRemark = invItemReturnViewModel.TransactionRemarks;

                    string[] arrItems = invItemReturnViewModel.JSonObject.Split(',');

                    foreach (var item in arrItems)
                    {
                        if (!string.IsNullOrEmpty(item))
                        {
                            string[] arrRetItems = item.Split("~!~");
                            ReturnItems Item = new()
                            {
                                ItemId = arrRetItems[0].ToString(),
                                IsUsable = arrRetItems[1].ToString()
                            };

                            returnItemList.Add(Item);
                        }
                    }

                    returnJson.ReturnItemList = returnItemList;

                    var jsonString = JsonConvert.SerializeObject(returnJson);

                    var result = await _invTransactionForIdRepository.TransactionReceiveJSonAsync(
                              BaseSpTcmPLGet(),
                              new ParameterSpTcmPL
                              {
                                  PParameterJson = jsonString
                              });
                    return result.PMessageType != BaseController.IsOk
                       ? throw new Exception(result.PMessageText.Replace("-", " "))
                       : (IActionResult)base.Json(new { success = true, response = result.PMessageText });
                }
                return Json(new { success = NotOk, response = "Error :-  Invalid data" });
                //return PartialView("_ModalInvItemRetrun", invItemReturnViewModel);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion InvTransactionIndex

        #region InvConsumables

        public async Task<IActionResult> InvConsumablesIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterConsumablesIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvConsumablesViewModel invConsumablesViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invConsumablesViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsConsumables(DTParameters param)
        {
            DTResult<InvConsumablesDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var data = await _invConsumablesDataTableListRepository.ConsumablesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        public IActionResult ConsumablesXLTemplate()
        {
            //var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);

            //var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            //var dictionaryAdjustType = new List<DictionaryItem>
            //{
            //};

            //dictionaryItems.AddRange(dictionaryAdjustType);

            //foreach (var item in leaveTypes)
            //{
            //    dictionaryItems.Add(
            //        new DictionaryItem { FieldName = "LeaveType", Value = item.DataValueField }
            //        );
            //}

            Stream ms = _excelTemplate.ExportConsumables("v01",
            new Library.Excel.Template.Models.DictionaryCollection(), 500);
            var fileName = "ImportConsumables.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            return File(ms, mimeType, fileName);
        }

        [HttpGet]
        public async Task<IActionResult> ConsumablesXLUpload()
        {
            var itemAssignmentTypeList = await _selectTcmPLRepository.InvConsumableItemTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ConsumableTypeList"] = new SelectList(itemAssignmentTypeList, "DataValueField", "DataTextField");

            //ViewBag["ConsumableTypeList"] = itemAssignmentTypeList;

            return PartialView("_ModalConsumablesUploadPartial");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConsumablesXLUpload(InvConsumableBulkCreateViewModel invConsumable)
        {
            if (!ModelState.IsValid)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Description is required."));
            }

            if (invConsumable.ConsumableType == "KEYRM")
            {
                if (invConsumable.RAMCapacity == 0)
                {
                    return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("RAM Capacity not selected."));
                }
            }

            var itemTypeRecord = await _invItemTypesDataTableListRepository.InvItemTypesDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = string.Empty,
                        PKeyId = invConsumable.ConsumableType,
                        PRowNumber = 0,
                        PPageLength = 10
                    }
                );
            const string TrackableItem = "C2";

            if ((invConsumable.file == null || invConsumable.file.Length == 0) && itemTypeRecord.FirstOrDefault().CategoryCode == TrackableItem)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("File not uploaded. Error executing procedure."));
            }
            // return Json(new { success = false, response = "File not uploaded due to an error" });

            try
            {
                string[] aryConsumables = Array.Empty<string>();
                string mimeType = string.Empty;
                string fileName = string.Empty;
                Stream stream = null;
                if (invConsumable.file != null)
                {
                    FileInfo fileInfo = new(invConsumable.file.FileName);

                    Guid storageId = Guid.NewGuid();
                    stream = invConsumable.file.OpenReadStream();
                    fileName = invConsumable.file.FileName;
                    var fileSize = invConsumable.file.Length;
                    mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                    // Check file validation
                    if (!fileInfo.Extension.Contains("xls"))
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("File uploaded not an excel file. Error executing procedure."));
                    }
                    //return Json(new { success = false, response = "Excel file not recognized" });

                    // Try to convert stream to a class

                    string json = string.Empty;

                    // Call database json stored procedure

                    List<Library.Excel.Template.Models.Consumable> consumables = _excelTemplate.ImportConsumables(stream);

                    aryConsumables = consumables.Select(p => p.ItemMfgId).ToArray();
                }
                //*********************************************
                //*********************************************
                //*********************************************
                //*********************************************

                var uploadOutPut = await _invConsumablesImportRepository.ImportConsumablesAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PConsumables = aryConsumables,
                            PConsumableType = invConsumable.ConsumableType,
                            PConsumableDesc = invConsumable.ConsumableDesc,
                            PQuantity = invConsumable.Quantity,
                            PRamCapacity = invConsumable.RAMCapacity,
                            PPoNumber = invConsumable.PO,
                            PPoDate = invConsumable.PODate,
                            PVendor = invConsumable.Vendor,
                            PInvoiceNo = invConsumable.Invoice,
                            PInvoiceDate = invConsumable.InvoiceDate,
                            PWarrantyEndDate = invConsumable.WarrantyEndDate,
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new();

                if (uploadOutPut.PConsumablesErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PConsumablesErrors)
                    {
                        string[] aryErr = err.Split("~!~");
                        importFileResults.Add(new ImportFileResultViewModel
                        {
                            ErrorType = (ImportFileValidationErrorTypeEnum)Enum.Parse(typeof(ImportFileValidationErrorTypeEnum), aryErr[5], true),
                            ExcelRowNumber = int.Parse(aryErr[2]),
                            FieldName = aryErr[3],
                            Id = int.Parse(aryErr[0]),
                            Section = aryErr[1],
                            Message = aryErr[6],
                        });
                    }
                }

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new();

                if (importFileResults.Count > 0)
                {
                    foreach (var item in importFileResults)
                    {
                        validationItems.Add(new ValidationItem
                        {
                            ErrorType = (Library.Excel.Template.Models.ValidationItemErrorTypeEnum)Enum.Parse(typeof(Library.Excel.Template.Models.ValidationItemErrorTypeEnum), item.ErrorType.ToString(), true),
                            ExcelRowNumber = item.ExcelRowNumber.Value,
                            FieldName = item.FieldName,
                            Id = item.Id,
                            Section = item.Section,
                            Message = item.Message
                        });
                    }
                }

                if (uploadOutPut.PMessageType == NotOk)
                {
                    if (importFileResults.Count > 0)
                    {
                        var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                        FileContentResult fileContentResult = File(streamError.ToArray(), mimeType, fileName);

                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent = fileContentResult
                        };

                        return Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults
                        };

                        return Json(resultJsonError);
                    }
                }
                else if (uploadOutPut.PMessageType == BaseController.IsOk)
                {
                    var resultJson = new
                    {
                        success = true,
                        response = "Import data successfully executed"
                    };

                    return base.Json(resultJson);
                }
                else
                {
                    var resultJson = new
                    {
                        success = false,
                        response = "Internal error - import unsucessful"
                    };

                    return base.Json(resultJson);
                }
            }
            catch (Exception ex)
            {
                var resultJson = new
                {
                    success = false,
                    response = ex.Message
                };

                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> InvConsumablesDetailIndex(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterConsumablesDetailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvConsumablesDetailViewModel invConsumablesDetailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            InvConsumablesDetails invConsumablesDetails = await _invConsumablesDetailsRepository.ConsumablesDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PConsumableId = id
                });

            invConsumablesDetailViewModel.ConsumableId = id;
            invConsumablesDetailViewModel.InvConsumablesDetails = invConsumablesDetails;

            return View(invConsumablesDetailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsConsumablesDetail(DTParameters param)
        {
            DTResult<InvConsumablesDetailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvConsumablesDetailDataTableList> data = await _invConsumablesDetailDataTableListRepository.ConsumablesDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PConsumableId = param.ConsumableId,
                        PGenericSearch = param.GenericSearch ?? " ",
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

        public async Task<IActionResult> GetRAMSelectList(string id)
        {
            IEnumerable<DataAccess.Models.DataField> itemList = Enumerable.Empty<DataAccess.Models.DataField>();

            if (id != "KEYRM")
            {
                return Json(itemList);
            }

            itemList = await _selectTcmPLRepository.InvRAMCapacityList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                });

            return Json(itemList);
        }

        #endregion InvConsumables

        #region Inv Item AddOns

        public async Task<IActionResult> InvItemAddOnIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterItemAddOnIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemAddOnViewModel invItemAddOnViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invItemAddOnViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsItemAddOn(DTParameters param)
        {
            DTResult<InvItemAddOnDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var data = await _invItemAddOnDataTableListRepository.ItemAddOnDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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

        public async Task<IActionResult> InvItemAddOnDetailIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterItemAddOnIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemAddOnViewModel invItemAddOnViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invItemAddOnViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsItemAddOnLog(DTParameters param)
        {
            DTResult<InvItemAddOnDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var data = await _invItemAddOnDataTableListRepository.ItemAddOnLogDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        public async Task<IActionResult> InvItemAddOnCreate()
        {
            if (TempData["Message"] != null)
            {
                TempData["Message"] = TempData["Message"];
            }
            var itemAddOnTypesList = await _selectTcmPLRepository.InvItemAddonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ItemAddOnTypesList"] = new SelectList(itemAddOnTypesList, "DataValueField", "DataTextField");

            InvItemAddOnTransCreateViewModel invItemAddOnTransCreateViewModel = new();

            return PartialView("_ModalInvItemAddonCreatePartial", invItemAddOnTransCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemAddOnCreate(InvItemAddOnTransCreateViewModel invItemAddOnTransCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invItemAddOnTransRepository.ItemAddOnTransCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAddonItemId = invItemAddOnTransCreateViewModel.AddonItemId,
                            PAddonItemTypeId = invItemAddOnTransCreateViewModel.AddonItemType,
                            PContainerItemId = invItemAddOnTransCreateViewModel.ContainerItemId,
                            PContainerItemTypeId = invItemAddOnTransCreateViewModel.ContainerItemType,
                            PRemarks = invItemAddOnTransCreateViewModel.Remarks
                        }
                    );

                    if (result.PMessageType != "OK")
                    {
                        Notify("Error", result.PMessageText, "toaster", NotificationType.error);
                    }
                    else
                    {
                        Notify("Success", result.PMessageText, "toaster", NotificationType.success);
                        return RedirectToAction("InvItemAddOnCreate");
                    }
                }
            }
            catch (Exception ex)
            {
                Notify("Error", StringHelper.CleanExceptionMessage(ex.Message), "toaster", NotificationType.error);
            }

            //AddOn Types
            var itemAddOnTypesList = await _selectTcmPLRepository.InvItemAddonTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ItemAddOnTypesList"] = new SelectList(itemAddOnTypesList, "DataValueField", "DataTextField");

            //Addon Items
            var itemAddOnItemsList = await _selectTcmPLRepository.InvItemAddonItemsList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PItemTypeKeyId = string.IsNullOrEmpty(invItemAddOnTransCreateViewModel.AddonItemType) ? "null" : invItemAddOnTransCreateViewModel.AddonItemType
            });

            ViewData["ItemAddOnItemsList"] = new SelectList(itemAddOnItemsList, "DataValueField", "DataTextField", invItemAddOnTransCreateViewModel.AddonItemId);

            //Container TYPES
            var itemContaierTypesList = await _selectTcmPLRepository.InvItemAddonContainerTypeList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PItemTypeKeyId = string.IsNullOrEmpty(invItemAddOnTransCreateViewModel.AddonItemType) ? "null" : invItemAddOnTransCreateViewModel.AddonItemType
            });

            ViewData["ItemContaierTypesList"] = new SelectList(itemContaierTypesList, "DataValueField", "DataTextField", invItemAddOnTransCreateViewModel.ContainerItemType);

            //Container Items list
            var itemAddOnContainerItemsList = await _selectTcmPLRepository.InvItemAddonItemsList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
                PItemTypeKeyId = string.IsNullOrEmpty(invItemAddOnTransCreateViewModel.ContainerItemType) ? "null" : invItemAddOnTransCreateViewModel.ContainerItemType
            });

            ViewData["ItemAddOnContainerItemsList "] = new SelectList(itemAddOnContainerItemsList, "DataValueField", "DataTextField", invItemAddOnTransCreateViewModel.ContainerItemId);

            return PartialView("_ModalInvItemAddonCreatePartial", invItemAddOnTransCreateViewModel);
        }

        [HttpGet]
        public async Task<IActionResult> GetItemAddOnItemsSelectList(string addOnItemTypeId)
        {
            _ = Enumerable.Empty<DataAccess.Models.DataField>();

            IEnumerable<DataField> itemList = await _selectTcmPLRepository.InvItemAddonItemsList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PItemTypeKeyId = addOnItemTypeId
                });

            return Json(itemList);
        }

        [HttpGet]
        public async Task<IActionResult> GetItemAddOnContainerTypesSelectList(string addOnItemTypeId)
        {
            _ = Enumerable.Empty<DataAccess.Models.DataField>();

            IEnumerable<DataField> itemList = await _selectTcmPLRepository.InvItemAddonContainerTypeList(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PItemTypeKeyId = addOnItemTypeId
                });

            return Json(itemList);
        }

        [HttpGet]
        public async Task<IActionResult> InvItemAddOnReturnAdd(string transId)
        {
            var data = await _invItemAddOnDataTableListRepository.ItemAddOnDataTableListAsync(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = transId,
                    PRowNumber = 0,
                    PPageLength = 100
                }
            );

            if (!data.Any())
            {
                Notify("Error", "Transaction Id not found.", "", NotificationType.error);
            }

            var jsonAddonData = JsonConvert.SerializeObject(data.FirstOrDefault());
            _ = new
            InvItemAddOnReturnViewModel();
            InvItemAddOnReturnViewModel invItemAddOnReturnViewModel = JsonConvert.DeserializeObject<InvItemAddOnReturnViewModel>(jsonAddonData);

            var itemUsableTypesList = await _selectTcmPLRepository.DMSItemUsableTypesList(BaseSpTcmPLGet(), null);
            ViewData["ItemUsableTypesList"] = new SelectList(itemUsableTypesList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvItemAddOnReturnPartial", invItemAddOnReturnViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemAddOnReturnAdd(InvItemAddOnReturnViewModel invItemAddOnReturn)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invItemAddOnTransRepository.ItemAddOnTransReturnAddAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PTransId = invItemAddOnReturn.TransId,
                            PItemUsable = invItemAddOnReturn.ItemUsable,
                            PRemarks = invItemAddOnReturn.ReturnRemarks
                        }
                    );

                    var resultJson = new
                    {
                        success = result.PMessageType == "OK",
                        response = result.PMessageText
                    };

                    return Json(resultJson);
                }
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }

            var itemUsableTypesList = await _selectTcmPLRepository.DMSItemUsableTypesList(BaseSpTcmPLGet(), null);
            ViewData["ItemUsableTypesList"] = new SelectList(itemUsableTypesList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvItemAddOnReturnPartial", invItemAddOnReturn);
        }

        #endregion Inv Item AddOns

        #region InvGroups

        public async Task<IActionResult> InvItemGroupIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterGroupsIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemGroupsViewModel invGroupsViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invGroupsViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsInvItemGroup(DTParameters param)
        {
            DTResult<InvItemGroupDataTableList> result = new();
            int totalRow = 0;

            try
            {
                var data = await _invItemGroupDataTableListRepository.GroupsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        public IActionResult InvItemGroupXLTemplate()
        {
            //var leaveTypes = await _selectTcmPLRepository.LeaveTypeListAsync(BaseSpTcmPLGet(), null);

            //var dictionaryItems = new List<Library.Excel.Template.Models.DictionaryItem>();

            //var dictionaryAdjustType = new List<DictionaryItem>
            //{
            //};

            //dictionaryItems.AddRange(dictionaryAdjustType);

            //foreach (var item in leaveTypes)
            //{
            //    dictionaryItems.Add(
            //        new DictionaryItem { FieldName = "LeaveType", Value = item.DataValueField }
            //        );
            //}

            Stream ms = _excelTemplate.ExportDMSInvGroupItems("v01",
            new Library.Excel.Template.Models.DictionaryCollection(), 500);
            var fileName = "ImportGroups.xlsx";
            var mimeType = MimeTypeMap.GetMimeType("xlsx");

            ms.Position = 0;
            return File(ms, mimeType, fileName);
        }

        [HttpGet]
        public IActionResult InvItemGroupXLUpload()
        {
            return PartialView("_ModalInvItemGroupUploadPartial");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvItemGroupXLUpload(InvItemGroupBulkCreateViewModel invItemGroup)
        {
            if (!ModelState.IsValid)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("Description is required."));
            }

            if (invItemGroup.file == null || invItemGroup.file.Length == 0)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("File not uploaded. Error executing procedure."));
            }
            // return Json(new { success = false, response = "File not uploaded due to an error" });

            try
            {
                string[] aryGroupItems = Array.Empty<string>();
                string mimeType = string.Empty;
                string fileName = string.Empty;
                Stream stream = null;
                if (invItemGroup.file != null)
                {
                    FileInfo fileInfo = new(invItemGroup.file.FileName);

                    Guid storageId = Guid.NewGuid();
                    stream = invItemGroup.file.OpenReadStream();
                    fileName = invItemGroup.file.FileName;
                    var fileSize = invItemGroup.file.Length;
                    mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                    // Check file validation
                    if (!fileInfo.Extension.Contains("xls"))
                    {
                        return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage("File uploaded not an excel file. Error executing procedure."));
                    }
                    //return Json(new { success = false, response = "Excel file not recognized" });

                    // Try to convert stream to a class

                    string json = string.Empty;

                    // Call database json stored procedure

                    List<Library.Excel.Template.Models.InvGroupItem> groupItems = _excelTemplate.ImportDMSInvGroupItems(stream);
                    /*
                    var dupItemCount = groupItems.GroupBy(x => x.ItemId).Count(x => x.Count() > 1);
                    if(dupItemCount > 0)
                        return StatusCode((int)HttpStatusCode.InternalServerError, "File contains duplicate items. Error execute procedure.");
                    */
                    aryGroupItems = groupItems.Select(p => p.ItemId).ToArray();
                }
                //*********************************************
                //*********************************************
                //*********************************************
                //*********************************************

                var uploadOutPut = await _invItemGroupImportRepository.ImportItemGroupAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PInvGroupDesc = invItemGroup.ItemGroupDesc,
                            PInvGroupItems = aryGroupItems
                        }
                    );

                List<ImportFileResultViewModel> importFileResults = new();

                if (uploadOutPut.PInvItemGroupErrors?.Length > 0)
                {
                    foreach (string err in uploadOutPut.PInvItemGroupErrors)
                    {
                        string[] aryErr = err.Split("~!~");
                        importFileResults.Add(new ImportFileResultViewModel
                        {
                            ErrorType = (ImportFileValidationErrorTypeEnum)Enum.Parse(typeof(ImportFileValidationErrorTypeEnum), aryErr[5], true),
                            ExcelRowNumber = int.Parse(aryErr[2]),
                            FieldName = aryErr[3],
                            Id = int.Parse(aryErr[0]),
                            Section = aryErr[1],
                            Message = aryErr[6],
                        });
                    }
                }

                List<Library.Excel.Template.Models.ValidationItem> validationItems = new();

                if (importFileResults.Count > 0)
                {
                    foreach (var item in importFileResults)
                    {
                        validationItems.Add(new ValidationItem
                        {
                            ErrorType = (Library.Excel.Template.Models.ValidationItemErrorTypeEnum)Enum.Parse(typeof(Library.Excel.Template.Models.ValidationItemErrorTypeEnum), item.ErrorType.ToString(), true),
                            ExcelRowNumber = item.ExcelRowNumber.Value,
                            FieldName = item.FieldName,
                            Id = item.Id,
                            Section = item.Section,
                            Message = item.Message
                        });
                    }
                }

                if (uploadOutPut.PMessageType != "OK")
                {
                    if (importFileResults.Count > 0)
                    {
                        var streamError = _excelTemplate.ValidateImport(stream, validationItems);
                        FileContentResult fileContentResult = File(streamError.ToArray(), mimeType, fileName);

                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults,
                            fileContent = fileContentResult
                        };

                        return Json(resultJsonError);
                    }
                    else
                    {
                        var resultJsonError = new
                        {
                            success = false,
                            response = uploadOutPut.PMessageText,
                            data = importFileResults
                        };

                        return Json(resultJsonError);
                    }
                }
                else
                {
                    var resultJson = new
                    {
                        success = true,
                        response = "Import data successfully executed"
                    };

                    return Json(resultJson);
                }
            }
            catch (Exception ex)
            {
                var resultJson = new
                {
                    success = false,
                    response = ex.Message
                };

                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> InvItemGroupDetailIndex(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterGroupDetailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemGroupDetailViewModel invItemGroupDetailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            InvItemGroupDetail invItemGroupDetail = await _invItemGroupDetailRepository.ItemGroupDetail(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PInvItemGroupId = id
                });

            invItemGroupDetailViewModel.GroupKeyId = id;
            invItemGroupDetailViewModel.InvItemGroupDetail = invItemGroupDetail;

            return View(invItemGroupDetailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsInvItemGroupDetail(DTParameters param)
        {
            DTResult<InvItemGroupDetailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvItemGroupDetailDataTableList> data = await _invItemGroupDetailDataTableListRepository.ItemGroupDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PInvItemGroupId = param.InvGroupId,
                        PGenericSearch = param.GenericSearch ?? " ",
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

        [HttpPost]
        public async Task<IActionResult> InvItemGroupDelete(string id)
        {
            try
            {
                var result = await _invItemGroupRepository.InvItemGroupDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGroupKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        #endregion InvGroups

        #region Inv Addons Container

        public async Task<IActionResult> InvAddOnContainerIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterInvAddOnContainerIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvAddOnContainerViewModel invAddOnContainerViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invAddOnContainerViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsInvAddOnContainer(string paramJson)
        {
            DTResult<InvAddOnContainerDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
                System.Collections.Generic.IEnumerable<InvAddOnContainerDataTableList> data = await _invAddOnContainerDataTableListRepository.InvAddOnContainerDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
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
        public async Task<IActionResult> InvAddOnContainerCreate()
        {
            InvAddOnContainerCreateViewModel invAddOnContainerCreateViewModel = new();

            var itemTypeList = await _selectTcmPLRepository.InvItemTypeFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ItemTypesList"] = new SelectList(itemTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvAddOnContainerCreatePartial", invAddOnContainerCreateViewModel);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvAddOnContainerCreate([FromForm] InvAddOnContainerCreateViewModel invAddOnContainerCreateViewModel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    var result = await _invAddOnContainerRepository.InvAddOnContainerCreateAsync(
                        BaseSpTcmPLGet(),
                        new ParameterSpTcmPL
                        {
                            PAddonItemId = invAddOnContainerCreateViewModel.AddonItemId,
                            PContainerItemId = invAddOnContainerCreateViewModel.ContainerItemId,
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

            var itemTypeList = await _selectTcmPLRepository.InvItemTypeFullList(BaseSpTcmPLGet(), new ParameterSpTcmPL
            {
            });

            ViewData["ItemTypesList"] = new SelectList(itemTypeList, "DataValueField", "DataTextField");

            return PartialView("_ModalInvAddOnContainerCreatePartial", invAddOnContainerCreateViewModel);
        }

        [HttpPost]
        public async Task<IActionResult> InvAddOnContainerDelete(string id)
        {
            try
            {
                var result = await _invAddOnContainerRepository.InvAddOnContainerDeleteAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PKeyId = id
                    }
                    );

                return Json(new { success = result.PMessageType == "OK", response = result.PMessageText });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> InvAddOnContainerExcelDownload()
        {
            try
            {
                var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterInvAddOnContainerIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                var timeStamp = DateTime.Now.ToFileTime();
                string fileName = "AddOn-Container Details_" + timeStamp.ToString();
                string reportTitle = "AddOn-Container Details ";
                string sheetName = "AddOn-Container Details";

                IEnumerable<InvAddOnContainerDataTableList> data = await _invAddOnContainerDataTableListRepository.InvAddOnContainerDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (data == null || !data.Any()) { throw new Exception("No Data Found"); }

                var json = JsonConvert.SerializeObject(data);

                IEnumerable<InvAddOnContainerDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<InvAddOnContainerDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, fileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion Inv Addons Container

        #region InvEmployeeTransactionIndex

        public async Task<IActionResult> InvEmployeeTransactionIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmployeeTransactionIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvEmployeeTransactionViewModel invEmployeeTransactionViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invEmployeeTransactionViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsEmployeeTransaction(DTParameters param)
        {
            DTResult<InvEmployeeTransactionDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvEmployeeTransactionDataTableList> data = await _invEmployeeTransactionDataTableListRepository.EmployeeTransactionDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        //public async Task<IActionResult> InvEmployeeTransactionDetailIndex(string id)
        //{
        //    Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
        //    {
        //        PModuleName = CurrentUserIdentity.CurrentModule,
        //        PMetaId = CurrentUserIdentity.MetaId,
        //        PPersonId = CurrentUserIdentity.EmployeeId,
        //        PMvcActionName = ConstFilterEmployeeTransactionDetailIndex
        //    });
        //    FilterDataModel filterDataModel = new();
        //    if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
        //    {
        //        filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
        //    }

        // InvEmployeeTransactionDetailViewModel invEmployeeTransactionDetailViewModel = new() {
        // FilterDataModel = filterDataModel };

        // InvEmployeeDetails invEmployeeDetails = await
        // _invEmployeeDetailsRepository.EmployeeDetails( BaseSpTcmPLGet(), new ParameterSpTcmPL {
        // PEmpno = id });

        // invEmployeeTransactionDetailViewModel.Empno = id;
        // invEmployeeTransactionDetailViewModel.InvEmployeeDetails = invEmployeeDetails;

        //    return View(invEmployeeTransactionDetailViewModel);
        //}

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> InvEmployeeTransactionDetailIndex(string empno)
        {
            if (string.IsNullOrEmpty(empno))
            {
                Notify("Error", "Invalid or blank Employee..", "toaster", NotificationType.error);
                return RedirectToAction("Index");
            }
            InvEmployeeTransactionDetailViewModel invEmployeeTransactionDetailViewModel = new();

            try
            {
                Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ConstFilterEmployeeTransactionDetailIndex
                });
                FilterDataModel filterDataModel = new();
                if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
                {
                    filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
                }

                invEmployeeTransactionDetailViewModel.FilterDataModel = filterDataModel;

                InvEmployeeDetails invEmployeeDetails = await _invEmployeeDetailsRepository.EmployeeDetails(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = empno
                    });

                var itemUsableTypesList = await _selectTcmPLRepository.DMSItemUsableTypesList(BaseSpTcmPLGet(), null);
                var tempItemUsableTypesList = new SelectList(itemUsableTypesList, "DataValueField", "DataTextField");
                string selectOption = string.Empty;
                foreach (var item in tempItemUsableTypesList)
                {
                    selectOption += $@" <option value=""{item.Value}"">{item.Text}</option> ";
                }

                //ViewData["ItemUsableTypesList"] = new SelectList(itemUsableTypesList, "DataValueField", "DataTextField");
                ViewData["ItemUsableTypesList"] = selectOption;

                invEmployeeTransactionDetailViewModel.Empno = empno;
                invEmployeeTransactionDetailViewModel.InvEmployeeDetails = invEmployeeDetails;
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
                return RedirectToAction("Index");
            }

            return View(invEmployeeTransactionDetailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsEmployeeTransactionDetail(DTParameters param)
        {
            DTResult<InvEmployeeTransactionDetailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvEmployeeTransactionDetailDataTableList> data = await _invEmployeeTransactionDetailDataTableListRepository.EmployeeTransactionDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno,
                        PTransTypeId = ConstPTransTypeIdIssue,
                        PGenericSearch = param.GenericSearch ?? " ",
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
        public async Task<IActionResult> InvEmployeeTransactionReservedIndex(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmployeeTransactionReservedIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvEmployeeTransactionDetailViewModel invEmployeeTransactionDetailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return PartialView("_InvTransactionIndex", invEmployeeTransactionDetailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsEmployeeTransactionReserved(DTParameters param)
        {
            DTResult<InvEmployeeTransactionDetailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvEmployeeTransactionDetailDataTableList> data = await _invEmployeeTransactionDetailDataTableListRepository.EmployeeTransactionDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno,
                        PTransTypeId = ConstPTransTypeIdReserve,
                        PGenericSearch = param.GenericSearch ?? " ",
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
        public async Task<IActionResult> InvEmployeeTransactionHistoryIndex(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterEmployeeTransactionHistoryIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvEmployeeTransactionDetailViewModel invEmployeeTransactionDetailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return PartialView("_InvEmployeeTransactionHistoryIndex", invEmployeeTransactionDetailViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsEmployeeTransactionHistory(DTParameters param)
        {
            DTResult<InvEmployeeTransactionDetailDataTableList> result = new();
            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvEmployeeTransactionDetailDataTableList> data = await _invEmployeeTransactionDetailDataTableListRepository.EmployeeTransactionDetailDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PEmpno = param.Empno,
                        PGenericSearch = param.GenericSearch ?? " ",
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

        #endregion InvEmployeeTransactionIndex

        #region LaptopLotWisePending

        public async Task<IActionResult> LaptopLotWiseIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterLaptopLotWiseIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            LaptopLotWiseViewModel laptopLotWiseViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(laptopLotWiseViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetLaptopLotWiseList(string paramJson)
        {
            DTResult<LaptopLotWiseDataTableList> result = new();
            int totalRow = 0;

            try
            {
                DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
                System.Collections.Generic.IEnumerable<LaptopLotWiseDataTableList> data = await _laptopLotWiseDataTableListRepository.LaptopLotWiseAllDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch,
                        PLot = param.Lot,
                        PStatus = param.Status,
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

        public async Task<IActionResult> LaptopLotWiseIssuedExcelDownload()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Laptop Lot Wise Issued Details_" + timeStamp.ToString();
                string reportTitle = "Laptop Lot Wise Issued Details ";
                string sheetName = "Laptop Lot Wise Issued Details";

                var dataLaptopLotwiseIssued = await _invLaptopLotwiseDataTableListExcelRepository.LaptopLotwiseIssuedDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (dataLaptopLotwiseIssued == null || !dataLaptopLotwiseIssued.Any()) { throw new Exception("No Data Found"); }

                var json = JsonConvert.SerializeObject(dataLaptopLotwiseIssued);

                IEnumerable<LaptopLotWiseDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<LaptopLotWiseDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                //return File(byteContent,
                //            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                //            fileName + ".xlsx");
                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, fileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> LaptopLotWisePendingExcelDownload()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Laptop Lot Wise Pending Details_" + timeStamp.ToString();
                string reportTitle = "Laptop Lot Wise Pending Details ";
                string sheetName = "Laptop Lot Wise pending Details";

                var dataLaptopLotwisePending = await _invLaptopLotwiseDataTableListExcelRepository.LaptopLotwisePendingDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (dataLaptopLotwisePending == null || !dataLaptopLotwisePending.Any()) { throw new Exception("No Data Found"); }

                var json = JsonConvert.SerializeObject(dataLaptopLotwisePending);

                IEnumerable<LaptopLotWiseDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<LaptopLotWiseDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                //return File(byteContent,
                //            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                //            fileName + ".xlsx");
                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, fileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        public async Task<IActionResult> LaptopLotWiseAllExcelDownload()
        {
            try
            {
                var timeStamp = DateTime.Now.ToFileTime();
                string fileName = "Laptop Lot Wise Details_" + timeStamp.ToString();
                string reportTitle = "Laptop Lot Wise Details ";
                string sheetName = "Laptop Lot Wise Details";

                var dataLaptopLotwiseAll = await _invLaptopLotwiseDataTableListExcelRepository.LaptopLotwiseAllDataTableListForExcelAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                    });

                if (dataLaptopLotwiseAll == null || !dataLaptopLotwiseAll.Any()) { throw new Exception("No Data Found"); }

                var json = JsonConvert.SerializeObject(dataLaptopLotwiseAll);

                IEnumerable<LaptopLotWiseDataTableExcel> excelData = JsonConvert.DeserializeObject<IEnumerable<LaptopLotWiseDataTableExcel>>(json);

                byte[] byteContent = _utilityRepository.ExcelDownloadFromIEnumerable(excelData, reportTitle, sheetName);

                //return File(byteContent,
                //            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                //            fileName + ".xlsx");
                var mimeType = MimeTypeMap.GetMimeType("xlsx");

                FileContentResult file = File(byteContent, mimeType, fileName);

                return Json(ResponseHelper.GetMessageObject("File downloaded successfully.", file));
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion LaptopLotWisePending

        #region filter

        private async Task<Domain.Models.FilterCreate> CreateFilter(string jsonFilter, string ActionName)
        {
            var retVal = await _filterRepository.FilterCreateAsync(new Domain.Models.FilterCreate
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,

                PMvcActionName = ActionName,
                PFilterJson = jsonFilter
            });
            return retVal;
        }

        private async Task<Domain.Models.FilterRetrieve> RetriveFilter(string ActionName)
        {
            var retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ActionName
            });
            return retVal;
        }

        public async Task<IActionResult> ResetFilter(string ActionId)
        {
            try
            {
                var result = await _filterRepository.FilterResetAsync(new Domain.Models.FilterReset
                {
                    PModuleName = CurrentUserIdentity.CurrentModule,
                    PMetaId = CurrentUserIdentity.MetaId,
                    PPersonId = CurrentUserIdentity.EmployeeId,
                    PMvcActionName = ActionId,
                });

                return Json(new { success = result.OutPSuccess == "OK", response = result.OutPMessage });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, response = ex.Message });
            }
        }

        public async Task<IActionResult> LaptopLotWiseFilterGet()
        {
            var retVal = await RetriveFilter(ConstFilterLaptopLotWiseIndex);

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }
            var lotList = await _selectTcmPLRepository.InvLaptopLotList(BaseSpTcmPLGet(), null);

            ViewData["LotList"] = new SelectList(lotList, "DataValueField", "DataTextField");

            return PartialView("_ModalLaptopLotWiseFilterSet", filterDataModel);
        }

        [HttpPost]
        public async Task<IActionResult> LaptopLotWiseFilterSet([FromForm] FilterDataModel filterDataModel)
        {
            try
            {
                string jsonFilter;
                jsonFilter = JsonConvert.SerializeObject(
                        new
                        {
                            filterDataModel.Lot,
                            filterDataModel.Status,
                        });

                _ = await CreateFilter(jsonFilter, ConstFilterLaptopLotWiseIndex);

                return Json(new
                {
                    success = true,
                    lot = filterDataModel.Lot,
                    status = filterDataModel.Status,
                });
            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, StringHelper.CleanExceptionMessage(ex.Message));
            }
        }

        #endregion filter

        #region Show transaction Employee wise using Popup window

        public async Task<IActionResult> SelectEmployee()
        {
            SelectEmployeeViewModel selectEmployeeViewModel = new();
            try
            {
                var dmsEmployeeList = await _selectTcmPLRepository.SWPEmployeeList4AdminAsync(BaseSpTcmPLGet(), null);

                ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField");
            }
            catch (Exception ex)
            {
                Notify("Error", ex.Message + " " + ex.InnerException?.Message, "toaster", NotificationType.error);
            }

            return PartialView("_ModalSelectEmployee", selectEmployeeViewModel);
        }

        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> SelectEmployee([FromForm] SelectEmployeeViewModel selectEmployeeViewModel)
        //{
        //    InvEmployeeTransactionDetailViewModel invEmployeeTransactionDetailViewModel = new InvEmployeeTransactionDetailViewModel();

        // try { Domain.Models.FilterRetrieve retVal = await
        // _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve { PModuleName =
        // CurrentUserIdentity.CurrentModule, PMetaId = CurrentUserIdentity.MetaId, PPersonId =
        // CurrentUserIdentity.EmployeeId, PMvcActionName =
        // ConstFilterEmployeeTransactionDetailIndex }); FilterDataModel filterDataModel = new(); if
        // (!string.IsNullOrEmpty(retVal.OutPFilterJson)) { filterDataModel =
        // JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson); }

        // invEmployeeTransactionDetailViewModel.FilterDataModel = filterDataModel;

        // InvEmployeeDetails invEmployeeDetails = await
        // _invEmployeeDetailsRepository.EmployeeDetails( BaseSpTcmPLGet(), new ParameterSpTcmPL {
        // PEmpno = selectEmployeeViewModel.Employee });

        // invEmployeeTransactionDetailViewModel.Empno = selectEmployeeViewModel.Employee;
        // invEmployeeTransactionDetailViewModel.InvEmployeeDetails = invEmployeeDetails;

        // return View("InvEmployeeTransactionDetailIndex", invEmployeeTransactionDetailViewModel);
        // } catch (Exception ex) { Notify("Error", ex.Message + " " + ex.InnerException?.Message,
        // "toaster", NotificationType.error); }

        //    var dmsEmployeeList = await _selectTcmPLRepository.DmsEmp4AsgmtList(BaseSpTcmPLGet(), null);
        //    ViewData["EmployeeList"] = new SelectList(dmsEmployeeList, "DataValueField", "DataTextField", selectEmployeeViewModel.Employee);
        //    return PartialView("_ModalSelectEmployee", selectEmployeeViewModel);
        //}

        #endregion Show transaction Employee wise using Popup window

        #region ItemNotInService

        public async Task<IActionResult> InvItemNotInServiceIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterItemNotInServiceIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvItemNotInServiceViewModel invItemNotInServiceViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invItemNotInServiceViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetItemNotInServiceList(string paramJson)
        {
            DTResult<InvItemNotInServiceDataTableList> result = new();
            int totalRow = 0;
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);
            try
            {
                System.Collections.Generic.IEnumerable<InvItemNotInServiceDataTableList> data = await _invItemNotInServiceDataTableListRepository.InvItemNotInServiceDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        #endregion ItemNotInService

        #region ReserveItems

        public async Task<IActionResult> InvReserveItemIndex()
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterReserveItemsIndex
            });

            FilterDataModel filterDataModel = new();

            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvTransactionViewModel invTransactionViewModel = new()
            {
                FilterDataModel = filterDataModel
            };

            return View(invTransactionViewModel);
        }

        [HttpGet]
        [ValidateAntiForgeryToken]
        public async Task<JsonResult> GetListsReserveItems(string paramJson)
        {
            DTResult<InvTransactionDataTableList> result = new();
            DTParameters param = Newtonsoft.Json.JsonConvert.DeserializeObject<DTParameters>(paramJson);

            int totalRow = 0;

            try
            {
                System.Collections.Generic.IEnumerable<InvTransactionDataTableList> data = await _invTransactionDataTableListRepository.TransactionReserveItemsDataTableListAsync(
                    BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PGenericSearch = param.GenericSearch ?? " ",
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

        public async Task<IActionResult> InvTransactionReserveItemsDetailIndex(string id)
        {
            Domain.Models.FilterRetrieve retVal = await _filterRepository.FilterRetrieveAsync(new Domain.Models.FilterRetrieve
            {
                PModuleName = CurrentUserIdentity.CurrentModule,
                PMetaId = CurrentUserIdentity.MetaId,
                PPersonId = CurrentUserIdentity.EmployeeId,
                PMvcActionName = ConstFilterTransactionDetailIndex
            });
            FilterDataModel filterDataModel = new();
            if (!string.IsNullOrEmpty(retVal.OutPFilterJson))
            {
                filterDataModel = JsonConvert.DeserializeObject<FilterDataModel>(retVal.OutPFilterJson);
            }

            InvTransactionDetailViewModel invTransactionDetailViewModel = new()
            {
                FilterDataModel = filterDataModel
            };
            _ = new InvTransactionDetails();
            InvTransactionDetails invTransactionDetails;

            ViewData["pagename"] = "ReserveItem";
            if (!string.IsNullOrEmpty(id))
            {
                invTransactionDetails = await _invTransactionDetailsRepository.TransactionDetails(
                BaseSpTcmPLGet(),
                new ParameterSpTcmPL
                {
                    PTransId = id,
                });
            }
            else
            {
                return View("InvTransactionDetailIndex", invTransactionDetailViewModel);
            }
            //return RedirectToAction("InvTransactionCreate");

            invTransactionDetailViewModel.TransId = id;
            invTransactionDetailViewModel.InvTransactionDetails = invTransactionDetails;

            return View("InvTransactionDetailIndex", invTransactionDetailViewModel);
        }

        #endregion ReserveItems
    }
}