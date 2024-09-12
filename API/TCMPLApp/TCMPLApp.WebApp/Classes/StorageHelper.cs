using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.DMS;

namespace TCMPLApp.WebApp.Classes
{
    public static class StorageHelper
    {
        public const string BaseRepository = "TCMPLAppBaseRepository";
        public const string TemplatesRepository = "TCMPLAppTemplatesRepository";

        public static class Attendance
        {
            public const string RepositoryMedicalCertificate = "AttendanceMedicalCertificate";

            public const string GroupMedicalCertificate = "MedicalCert";
        }

        public static class LC
        {
            public const string RepositoryLc = "LetterOfCredit";

            public const string GroupLc = "";
        }

        public static class EmpGenInfo
        {
            public const string RepositoryEmpGenInfo = "EmpGenInfo";

            public const string GroupEmpGenInfoPassport = "PP";
            public const string GroupEmpGenInfoAadharCard = "AC";
            public const string GroupEmpGenInfoGTLI = "GT";
            
            public const string Group = "";
        }

        public static class BG
        {
            public const string RepositoryBG = "BankGuarantee";

            public const string GroupBG = "";
        }

        public static class Offboarding
        {
            public const string TCMPLAppTemplatesRepository = "TCMPLAppTemplatesRepository";
            public const string Repository = "OffBoarding";
            public const string Group = "";
        }

        public static class SWP
        {
            public const string TCMPLAppTemplatesRepository = "TCMPLAppTemplatesRepository";
            public const string RepositorySWP = @"SWP";
            public const string Repository = "";
            public const string GroupLc = "";
        }
        public static class SelfService
        {
            public const string TCMPLAppTemplatesRepository = "TCMPLAppTemplatesRepository";
            public const string RepositorySelfService = "SelfService";
            public const string Group = "";
        }
        public static class DeskBooking
        {
            public const string TCMPLAppTemplatesRepository = "TCMPLAppTemplatesRepository";
            public const string RepositoryDeskBooking = "DeskBooking";
            public const string Group = "";
        }
        public static class ERS
        {
            public const string Repository = "EmployeeReferalScheme";
            public const string Group = "";
        }

        public static class RSVP
        {
            public const string Repository = "RSVP";
            public const string Group = "";
        }

        public static class DMS
        {
            public const string Repository = "DeskManagement";
            public const string Group = "";
        }

        public static class JOB
        {
            public const string TCMPLAppTemplatesRepository = "TCMPLAppTemplatesRepository";

            //public const string RepositoryExcelTemplateJobMaster = "ExcelTemplateJobMaster";
            public const string RepositoryJobForm = "JobForm";

            public const string RepositoryJobPhasesErps = "JobPhasesErps";
            public const string Group = "";
        }

        public static class DigiForm
        {
            public const string TCMPLAppTemplatesRepository = "TCMPLAppTemplatesRepository";
            public const string RepositoryDigiForm = "DigiForm";
            public const string Group = "";
        }

        public static class RAPTimesheet
        {
            public const string TCMPLAppTemplatesRepository = "TCMPLAppTemplatesRepository";
            public const string RepositoryRAPTimesheet = "RAPTimesheet";
            public const string Group = "";
        }

        public static async Task<string> SaveFileAsync(string AreaRepository, string EmpnoKeyId, string GroupName, IFormFile File, IConfiguration _configuration)
        {
            var baseRepository = _configuration[BaseRepository];

            var areaRepository = _configuration["AreaRepository:" + AreaRepository];

            var folder = Path.Combine(baseRepository, areaRepository);

            if (!System.IO.Directory.Exists(folder))
            {
                System.IO.Directory.CreateDirectory(folder);
            }

            var fileName = EmpnoKeyId + "_" + GroupName + "_" + (System.IO.Path.GetRandomFileName()).Replace(".", "") + Path.GetExtension(File.FileName);

            var fileNamePath = Path.Combine(folder, fileName);

            using (Stream fileStream = new FileStream(fileNamePath, FileMode.Create))
            {
                await File.CopyToAsync(fileStream);
            }
            return fileName;
        }

        public static void DeleteFile(string AreaRepository, string FileName, IConfiguration _configuration)
        {
            var baseRepository = _configuration[BaseRepository];

            var areaRepository = _configuration["AreaRepository:" + AreaRepository];

            var FileNamePath = Path.Combine(baseRepository, areaRepository, FileName);
            if (System.IO.File.Exists(FileNamePath))
                System.IO.File.Delete(FileNamePath);
        }

        public static byte[] DownloadFile(string AreaRepository, string FileName, IConfiguration _configuration)
        {
            var baseRepository = _configuration[BaseRepository];

            var areaRepository = _configuration["AreaRepository:" + AreaRepository];

            var folder = Path.Combine(baseRepository, areaRepository);
            var file = Path.Combine(folder, FileName);

            return System.IO.File.ReadAllBytes(file);
        }

        public static string GetFilePath(string AreaRepository, string FileName, IConfiguration _configuration)
        {
            var baseRepository = _configuration[BaseRepository];

            var areaRepository = _configuration["AreaRepository:" + AreaRepository];

            var folder = Path.Combine(baseRepository, areaRepository);

            var file = Path.Combine(folder, FileName);

            return file.ToString().Trim();
        }

        public static string GetTemplateFilePath(string AreaRepository, string FileName, IConfiguration _configuration)
        {
            var templatesRepository = _configuration[TemplatesRepository];

            var areaRepository = _configuration["AreaRepository:" + AreaRepository];

            var folder = Path.Combine(templatesRepository, areaRepository);

            var file = Path.Combine(folder, FileName);

            return file.ToString().Trim();
        }

        public static byte[] DirectDownloadFile(string FileWithFullPath)
        {
            var file = Path.Combine(FileWithFullPath);

            return System.IO.File.ReadAllBytes(file);
        }
    }
}