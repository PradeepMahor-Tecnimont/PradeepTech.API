// See https://aka.ms/new-console-template for more information
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApps.Library.Excel.Template.Test
{
    internal class Program
    {
        private static IServiceProvider _serviceProvider;
        //private static IConfiguration _configuration;
        //private static string? _connectionString;
        //private static BaseSpTcmPL _baseSpTcmPL;
        //private static string _redisCacheString;

        private static void Main(string[] args)
        {
            var builder = new ConfigurationBuilder();

            //builder.AddUserSecrets<Program>();

            // Setup Database connection
            //_connectionString = _configuration.GetConnectionString("ViewContext");
            //_redisCacheString = _configuration.GetConnectionString("RedisCache");

            //_baseSpTcmPL = new BaseSpTcmPL
            //{
            //    PMetaId = (_configuration["AppSettings:MetaId"]),
            //    PPersonId = (_configuration["AppSettings:{PersonId"])

            //    //UIAppId = short.Parse(_configuration["AppSettings:AppId"]),
            //    //UIEntityId = short.Parse(_configuration["AppSettings:EntityId"]),
            //    //UIProfileId = short.Parse(_configuration["AppSettings:ProfileId"]),
            //    //UIUserId = Guid.Parse(_configuration["AppSettings:UserId"]),
            //    //UICultureInfoId = "en-US"
            //};

            RegisterServices();

            var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();

            //ExportDMSDeskAreaUserList(excelTemplate);
            ImportLopExcessLeave();
            //var eboItemPackingListTemplateMasterHeaderExcelRepository = _serviceProvider.GetService<ISelectRepository>();
            //var attendanceDeskDetailsRepository = _serviceProvider.GetService<IAttendanceDeskDetailsRepository>();
            //var selectRepository = _serviceProvider.GetService<ISelectRepository>();

            //ExportPurchaseOrder(excelTemplate,
            //    eboItemOrderTemplateHeaderExcelRepository,
            //    eboItemOrderTemplateBodyExcelRepository,
            //    selectRepository).GetAwaiter().GetResult();

            //ImportPurchaseOrder(excelTemplate);
            //ImportPurchaseOrderRev01(excelTemplate);
            //ValidatePurchaseOrder(excelTemplate, selectRepository).GetAwaiter().GetResult();

            //T C M P L   A P P    B E G I N

            //CreateImportLeaveClaims(excelTemplate);
            //CreateImportEmployeeMaster(excelTemplate);

            //UploadExcelData();

            //ImportExcelHRMastersCustom();

            //ExportEmpComingToOffice(excelTemplate);

            //ExportDMSConsumables(excelTemplate);

            //ImportDMSConsumables();

            //ExportDMSInvGroups(excelTemplate);



            //ImportDMSInvGroups();

            //ExportDMSEmpAssetsMovement();

            //ImportDMSEmpAssetsMovement();

            //ImportJobmasterBudget();

            //ExportJobmasterBudget(excelTemplate);

            //ExportHRMastersCustom(excelTemplate);

            //ImportHRMastersCustom();

            //ExportDMSDeskAreaDeskList(excelTemplate);

            //T C M P L   A P P    E N D

            //ExportPackingList(excelTemplate,
            //    eboItemPackingListTemplateMasterHeaderExcelRepository,
            //    eboItemPackingListTemplateMasterBodyExcelRepository,
            //    eboItemPackingListTemplateItemHeaderExcelRepository,
            //    eboItemPackingListTemplateItemBodyExcelRepository).GetAwaiter().GetResult();

            //ExportMarkingList(excelTemplate,
            //    eboItemPackingListTemplateMasterHeaderExcelRepository,
            //    eboItemPackingListTemplateMasterBodyExcelRepository,
            //    eboItemPackingListTemplateItemHeaderExcelRepository,
            //    eboItemPackingListTemplateItemBodyExcelRepository).GetAwaiter().GetResult();

            //CreateImportCustomerContactTemplate(excelTemplate);
            //ImportCustomerContact(excelTemplate);
            //ValidateCustomerContact(excelTemplate);

            //CreateImportDeviceScheduleTemplate(excelTemplate);
            //ImportDeviceSchedule(excelTemplate);
            //ValidateDeviceSchedule(excelTemplate);

            //CreateActionPackingListLoadingPlanTemplate(excelTemplate, eboItemPackingListLoadingPlanProgressiveRepository).GetAwaiter().GetResult();
            //ActionPackingListLoadingPlan(excelTemplate);
            //ValidateActionPackingListLoadingPlan(excelTemplate);

            //ImportMBL(excelTemplate);
            //ValidateMBL(excelTemplate);

            //CreateImportDynamicFormBrick(excelTemplate);
            //ValidateDynamicFormBrick(excelTemplate);

            //CreateImportDynamicFormBrickCultureInfo(excelTemplate);

            //CreateImportProjectDynamicFormTemplate(excelTemplate);
            //ValidateProjectDynamicFormTemplate(excelTemplate);

            //ExportMasterDataMTO(excelTemplate,
            //    eboItemOrderTemplateHeaderExcelRepository,
            //    eboItemOrderTemplateBodyExcelRepository,
            //    selectRepository).GetAwaiter().GetResult();

            //ImportMasterDataMTO(excelTemplate);

            //ExportLayoutMTO(excelTemplate,
            //    eboItemMaterialTakeOffTemplateHeaderExcelRepository,
            //    eboItemMaterialTakeOffTemplateBodyExcelRepository).GetAwaiter().GetResult();

            //CreateImportDynamicFormSectionCultureInfo(excelTemplate);

            DisposeServices();
        }

        private static void RegisterServices()
        {
            var collection = new ServiceCollection();

            // Database
            //collection.AddSingleton(s => new ViewContextOption(true));

            //collection.AddDbContext<ViewContext>(options =>
            //    options.UseSqlServer(_connectionString));

            //collection.AddSingleton<IEboItemPackingListTemplateMasterHeaderExcelRepository, EboItemPackingListTemplateMasterHeaderExcelRepository>();
            //collection.AddSingleton<IEboItemPackingListTemplateMasterBodyExcelRepository, EboItemPackingListTemplateMasterBodyExcelRepository>();
            //collection.AddSingleton<IEboItemPackingListTemplateItemHeaderExcelRepository, EboItemPackingListTemplateItemHeaderExcelRepository>();
            //collection.AddSingleton<IEboItemPackingListTemplateItemBodyExcelRepository, EboItemPackingListTemplateItemBodyExcelRepository>();

            //collection.AddSingleton<IEboItemOrderTemplateHeaderExcelRepository, EboItemOrderTemplateHeaderExcelRepository>();
            //collection.AddSingleton<IEboItemOrderTemplateBodyExcelRepository, EboItemOrderTemplateBodyExcelRepository>();
            //collection.AddSingleton<IEboItemPackingListLoadingPlanProgressiveRepository, EboItemPackingListLoadingPlanProgressiveRepository>();
            //collection.AddSingleton<ISelectRepository, SelectRepository>();
            //collection.AddSingleton<IEboItemMaterialTakeOffTemplateHeaderExcelRepository, EboItemMaterialTakeOffTemplateHeaderExcelRepository>();
            //collection.AddSingleton<IEboItemMaterialTakeOffTemplateBodyExcelRepository, EboItemMaterialTakeOffTemplateBodyExcelRepository>();

            collection.AddSingleton<IExcelTemplate, ExcelTemplate>();

            //collection.AddLogging();
            //collection.AddSingleton<CachingFramework.Redis.Contracts.IContext, RedisContext>(r => new RedisContext(_redisCacheString));

            _serviceProvider = collection.BuildServiceProvider();
        }

        private static void DisposeServices()
        {
            if (_serviceProvider == null)
            {
                return;
            }
            if (_serviceProvider is IDisposable)
            {
                ((IDisposable)_serviceProvider).Dispose();
            }
        }

        #region

        private static void ExportDMSDeskAreaUserList(IExcelTemplate excelTemplate)
        {
            using (MemoryStream stream = excelTemplate.ExportDMSDeskAreaUserList("v01",
                    new DictionaryCollection
                    {
                        DictionaryItems = new List<DictionaryItem>()
                    }, 500))
            {
                FileStream file = new FileStream(@"C:\Temp\Test_DMSDeskAreaUserList.xlsx", FileMode.Create, FileAccess.Write);
                stream.WriteTo(file);
            }
        }


        private static void CreateImportLeaveClaims(IExcelTemplate excelTemplate)
        {
            using (MemoryStream stream = excelTemplate.ExportLeaveClaims("v01", new DictionaryCollection
            {
                DictionaryItems = new List<DictionaryItem>
                    {
                        new DictionaryItem
                        {
                            FieldName="LeaveType",
                            Value="CL"
                        },
                        new DictionaryItem
                        {
                            FieldName="LeaveType",
                            Value="PL"
                        },
                        new DictionaryItem
                        {
                            FieldName="LeaveType",
                            Value="SL"
                        },
                        new DictionaryItem
                        {
                            FieldName="LeaveType",
                            Value="CO"
                        }
                    }
            }, 500))
            {
                FileStream file = new FileStream(@"C:\Temp\test.xlsx", FileMode.Create, FileAccess.Write);
                stream.WriteTo(file);
            }
        }

        private static void ExportEmpComingToOffice(IExcelTemplate excelTemplate)
        {
            using (MemoryStream stream = excelTemplate.ExportEmpComingToOffice("v01",
                    new DictionaryCollection
                    {
                        DictionaryItems = new List<DictionaryItem>()
                    }, 500))
            {
                FileStream file = new FileStream(@"C:\Temp\test.xlsx", FileMode.Create, FileAccess.Write);
                stream.WriteTo(file);
            }
        }

        private static void ExportDMSConsumables(IExcelTemplate excelTemplate)
        {
            using (MemoryStream stream = excelTemplate.ExportConsumables("v01",
                    new DictionaryCollection
                    {
                        DictionaryItems = new List<DictionaryItem>()
                    }, 500))
            {
                FileStream file = new FileStream(@"C:\Temp\test.xlsx", FileMode.Create, FileAccess.Write);
                stream.WriteTo(file);
            }
        }

        private static void ImportDMSConsumables()
        {
            MemoryStream stream = new MemoryStream(File.ReadAllBytes(@"C:\\temp\\ImportDMSConsumables.xlsx"));

            var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
            List<Consumable>? employees = excelTemplate?.ImportConsumables(stream);
            var count = employees?.Count();
        }

        private static void ExportDMSInvGroups(IExcelTemplate excelTemplate)
        {
            using (MemoryStream stream = excelTemplate.ExportDMSInvGroupItems("v01",
                    new DictionaryCollection
                    {
                        DictionaryItems = new List<DictionaryItem>()
                    }, 500))
            {
                FileStream file = new FileStream(@"C:\Temp\test.xlsx", FileMode.Create, FileAccess.Write);
                stream.WriteTo(file);
            }
        }

        private static void ImportDMSInvGroups()
        {
            MemoryStream stream = new MemoryStream(File.ReadAllBytes(@"C:\\temp\\ImportDMSConsumables.xlsx"));

            var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
            List<InvGroupItem>? items = excelTemplate?.ImportDMSInvGroupItems(stream);
            var count = items?.Count();
        }

        private static void ImportLopExcessLeave()
        {
            MemoryStream stream = new MemoryStream(File.ReadAllBytes(@"C:\\temp\\ImportLoPForExcessLeave.xlsx"));

            var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
            List<LopForExcessLeave>? items = excelTemplate?.ImportLopForExcessLeave(stream);
            var count = items?.Count();
        }
        private static void CreateImportEmployeeMaster(IExcelTemplate excelTemplate)
        {
            using (MemoryStream stream = excelTemplate.ExportEmployeeMaster("v01",
                    new DictionaryCollection
                    {
                        DictionaryItems = new List<DictionaryItem>()
                    }, 500))
            {
                FileStream file = new FileStream(@"C:\Temp\test.xlsx", FileMode.Create, FileAccess.Write);
                stream.WriteTo(file);
            }
        }

        private static void UploadExcelData()
        {
            MemoryStream stream = new MemoryStream(File.ReadAllBytes(@"C:\Users\Deven\\downloads\\ImportEmployeeMaster-1.xlsx"));

            var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
            List<Employee>? employees = excelTemplate?.ImportEmployeeMaster(stream);
        }

        #endregion

        #region ImportDynamicFormBrick

        //private static void CreateImportDynamicFormBrick(IExcelTemplate excelTemplate)
        //{
        //    try
        //    {
        //        using (MemoryStream stream = excelTemplate.ExportDynamicFormBrick("v01", new DictionaryCollection
        //        {
        //            DictionaryItems = new List<DictionaryItem>
        //            {
        //                new DictionaryItem
        //                {
        //                    FieldName="Action",
        //                    Value="ADD"
        //                },
        //                new DictionaryItem
        //                {
        //                    FieldName="Action",
        //                    Value="UPD"
        //                },
        //                new DictionaryItem
        //                {
        //                    FieldName="Action",
        //                    Value="DEL"
        //                },
        //                new DictionaryItem
        //                {
        //                    FieldName="UnitMeasure",
        //                    Value="Activity unit"
        //                },
        //                new DictionaryItem
        //                {
        //                    FieldName="UnitMeasure",
        //                    Value="Centimeter"
        //                },
        //            }
        //        }, 500))
        //        {
        //            FileStream file = new FileStream(@"C:\Temp\test.xlsx", FileMode.Create, FileAccess.Write);
        //            stream.WriteTo(file);
        //        }

        //    }
        //    catch (ArgumentException exArg)
        //    {
        //        Console.WriteLine("{0}: {1}", exArg.GetType().Name, exArg.Message);
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine(ex.Message);
        //    }
        //}

        //private static void ImportDynamicFormBrick(IExcelTemplate excelTemplate)
        //{
        //    try
        //    {
        //        using (var ms = new MemoryStream())
        //        {
        //            using (var fileStream = new FileStream(@"c:\temp\test.xlsx", FileMode.Open, FileAccess.Read))
        //            {
        //                fileStream.CopyTo(ms);
        //            }

        // var dynamicFormBricks = excelTemplate.ImportDynamicFormBrick(ms);

        // }

        //    }
        //    catch (ArgumentException exArg)
        //    {
        //        Console.WriteLine("{0}: {1}", exArg.GetType().Name, exArg.Message);
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine(ex.Message);
        //    }
        //}

        //private static void ValidateDynamicFormBrick(IExcelTemplate excelTemplate)
        //{
        //    try
        //    {
        //        using (var ms = new MemoryStream())
        //        {
        //            using (var fileStream = new FileStream(@"c:\temp\test.xlsx", FileMode.Open, FileAccess.Read))
        //            {
        //                fileStream.CopyTo(ms);
        //            }

        // var stream = excelTemplate.ValidateImport(ms, new List<ValidationItem> { new
        // ValidationItem { ExcelRowNumber = 1, FieldName = "FirstName", ErrorType =
        // ValidationItemErrorTypeEnum.Critical, Message = "Errore critico" }, new ValidationItem {
        // ExcelRowNumber = 2, FieldName = "MobileNumber", ErrorType =
        // ValidationItemErrorTypeEnum.Warning, Message = "Warning" } });

        // FileStream file = new FileStream(@"C:\Temp\test_validated.xlsx", FileMode.Create,
        // FileAccess.Write); stream.WriteTo(file);

        // }

        //    }
        //    catch (ArgumentException exArg)
        //    {
        //        Console.WriteLine("{0}: {1}", exArg.GetType().Name, exArg.Message);
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine(ex.Message);
        //    }
        //}

        #endregion

        #region Private

        //Get img byte array from internet
        //private static MemoryStream GetCustomLogo()
        //{
        //    using (WebClient client = new WebClient())
        //    using (Stream stream = client.OpenRead("https://www.kt-met.com/sites/default/files/header_dark_logo/logo.png"))
        //    {
        //        MemoryStream ms = new MemoryStream();
        //        stream.CopyTo(ms);
        //        return ms;
        //    }
        //}

        #endregion

        #region ImportJobMaster

        private static void ImportJobmasterBudget()
        {
            MemoryStream stream = new MemoryStream(File.ReadAllBytes(@"C:\temp\ImportJobmasterBudgetSample.xlsx"));

            var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
            List<JobmasterBudget>? budgetes = excelTemplate?.ImportJobmasterBudget(stream);
            var count = budgetes?.Count();
        }

        private static void ExportJobmasterBudget(IExcelTemplate excelTemplate)
        {
            var dictionaryItems = new List<DictionaryItem>();

            dictionaryItems.Add(new DictionaryItem
            {
                FieldName = "LeaveType",
                Value = "CL"
            });

            dictionaryItems.Add(new DictionaryItem
            {
                FieldName = "LeaveType",
                Value = "PL"
            });

            dictionaryItems.Add(new DictionaryItem
            {
                FieldName = "LeaveType",
                Value = "SL"
            });

            dictionaryItems.Add(new DictionaryItem
            {
                FieldName = "LeaveType",
                Value = "CO"
            });

            using (MemoryStream stream = excelTemplate.ExportJobmasterBudget("v01", new DictionaryCollection
            {
                DictionaryItems = dictionaryItems
            }, 500))
            {
                FileStream file = new FileStream(@"C:\temp\Sample_JobmasterBudget_new.xlsx", FileMode.Create, FileAccess.Write);
                stream.WriteTo(file);
            }

            //using (MemoryStream stream = excelTemplate.ExportJobmasterBudget("v01", new DictionaryCollection
            //{
            //    DictionaryItems = new List<DictionaryItem>
            //        {
            //            new DictionaryItem
            //            {
            //                FieldName="CostcodeName",
            //                Value="0221"
            //            },
            //            new DictionaryItem
            //            {
            //                FieldName="CostcodeName",
            //                Value="0217"
            //            },
            //            new DictionaryItem
            //            {
            //                FieldName="CostcodeName",
            //                Value="D062"
            //            },
            //            new DictionaryItem
            //            {
            //                FieldName="CostcodeName",
            //                Value="D021"
            //            }
            //        }
            //}, 500))
            //{
            //    FileStream file = new FileStream(@"C:\temp\Sample_JobmasterBudget_new.xlsx", FileMode.Create, FileAccess.Write);
            //    stream.WriteTo(file);
            //}
        }

        #endregion

        #region ImportDMSMovements
        //private static void ImportDMSEmpAssetsMovement()
        //{
        //    MemoryStream stream = new MemoryStream(File.ReadAllBytes(@"C:\\temp\\testImport.xlsx"));

        //    var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
        //    List<EmpAssetMovementMovement>? items = excelTemplate?.ImportDMSEmpAssetMovement(stream);
        //    var count = items?.Count();
        //}

        //private static void ExportDMSEmpAssetsMovement()
        //{
        //    var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
        //    if (excelTemplate != null)
        //    {
        //        using (MemoryStream stream = excelTemplate.ExportDMSEmpAssetMovement("v01",
        //                new DictionaryCollection
        //                {
        //                    DictionaryItems = new List<DictionaryItem>
        //            {
        //                new DictionaryItem
        //                {
        //                    FieldName="MoveAssets",
        //                    Value="Yes"
        //                },
        //                new DictionaryItem
        //                {
        //                    FieldName="MoveAssets",
        //                    Value="No"
        //                },
        //                new DictionaryItem
        //                {
        //                    FieldName="MoveEmployee",
        //                    Value="Yes"
        //                },
        //                new DictionaryItem
        //                {
        //                    FieldName="MoveEmployee",
        //                    Value="No"
        //                }
        //            }
        //                }, 500))
        //        {
        //            FileStream file = new FileStream(@"C:\Temp\test.xlsx", FileMode.Create, FileAccess.Write);
        //            stream.WriteTo(file);
        //        }
        //    }
        //}

        #endregion

        #region ImportHRMasterCustom

        private static void ExportHRMastersCustom(IExcelTemplate excelTemplate)
        {
            var dictionaryItems = new List<DictionaryItem>();

            using (MemoryStream stream = excelTemplate.ExportHRMastersCustom("v01", new DictionaryCollection
            {
                DictionaryItems = dictionaryItems
            }, 500))
            {
                FileStream file = new FileStream(@"C:\Temp\xlsHRMastersCustom.xlsx", FileMode.Create, FileAccess.Write);
                stream.WriteTo(file);
            }
        }

        private static void ImportHRMastersCustom()
        {
            MemoryStream stream = new MemoryStream(File.ReadAllBytes(@"C:\\temp\\ImportHRMasterCustomData_Test.xlsx"));

            var excelTemplate = _serviceProvider.GetService<IExcelTemplate>();
            List<EmployeeCustom>? items = excelTemplate?.ImportHRMastersCustom(stream);
            var count = items?.Count();
        }

        #endregion
    }
}