using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLAPP.WinService
{
    public static class StorageHelper
    {
        //public const string TCMPLAppBaseRepository = "TCMPLAppBaseRepository";
        public const string TCMPLAppDownloadRepository = "AreaRepository:TCMPLAppDownloadRepository";
        public const string TCMPLAppTemplatesRepository = "AreaRepository:TCMPLAppTemplatesRepository";
        public const string TCMPLAppMailAttachmentPickUpRepository = "TCMPLAppMailAttachmentPickUpRepository";

        public static class Attendance
        {
            public const string RepositoryMedicalCertificate = "AreaRepository:AttendanceMedicalCertificate";

            public const string GroupMedicalCertificate = "MedicalCert";
        }

        public static class LC
        {
            public const string RepositoryLc = "AreaRepository:LetterOfCredit";

            public const string GroupLc = "";
        }

        public static class Offboarding
        {
            public const string Repository = "AreaRepository:OffBoarding";
            public const string Group = "";
        }

        public static class SWP
        {
            //public const string RepositoryExcelTemplate = @"ExcelTemplateForSWP";
            public const string SWPRepository = "AreaRepository:SWP";
            public const string Repository = "";
            public const string GroupLc = "";
        }


        public static class EmpGenInfo
        {
            public const string RepositoryEmpGenInfo = "AreaRepository:EmpGenInfo";

            public const string GroupEmpGenInfoPassport = "AreaRepository:PP";
            public const string GroupEmpGenInfoAadharCard = "AreaRepository:AC";
            public const string GroupEmpGenInfoGTLI = "AreaRepository:GT";

            public const string Group = "";
        }


        public static async Task<string> SaveFileAsync(string RepositoryName, string EmpnoKeyId, string GroupName, IFormFile File, IConfiguration _configuration)
        {
            //var baseRepository = _configuration[TCMPLAppBaseRepository];
            var downloadRepository = _configuration[TCMPLAppDownloadRepository];

            var repository = _configuration[ RepositoryName];

            //var folder = Path.Combine(baseRepository, areaRepository);
            var folder = Path.Combine(downloadRepository, repository);

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

        public static void DeleteFile(string RepositoryName, string FileName, IConfiguration _configuration)
        {
            //var baseRepository = _configuration[TCMPLAppBaseRepository];
            var downloadRepository = _configuration[TCMPLAppDownloadRepository];

            var repository = _configuration[ RepositoryName];

            //var FileNamePath = Path.Combine(baseRepository, areaRepository, FileName);
            var FileNamePath = Path.Combine(downloadRepository, repository, FileName);

            if (System.IO.File.Exists(FileNamePath))
                System.IO.File.Delete(FileNamePath);
        }

        public static byte[] DownloadFile(string RepositoryName, string FileName, IConfiguration _configuration)
        {
            //var baseRepository = _configuration[TCMPLAppBaseRepository];
            var downloadRepository = _configuration[TCMPLAppDownloadRepository];

            var repository = _configuration[RepositoryName];

            //var folder = Path.Combine(baseRepository, areaRepository);
            var folder = Path.Combine(downloadRepository, repository);

            var file = Path.Combine(folder, FileName);

            return System.IO.File.ReadAllBytes(file);
        }

        public static string GetFilePath(string RepositoryName, string FileName, IConfiguration _configuration)
        {
            //var baseRepository = _configuration[TCMPLAppBaseRepository];
            var templatesRepository = _configuration[TCMPLAppTemplatesRepository];

            var repository = _configuration[RepositoryName];

            //var folder = Path.Combine(baseRepository, areaRepository);
            var folder = Path.Combine(templatesRepository, repository);

            var file = Path.Combine(folder, FileName);

            return file.ToString().Trim();
        }

        public static string GetTemplateFilePath(string RepositoryName, string FileName, IConfiguration _configuration)
        {
            var templatesRepository = _configuration[TCMPLAppTemplatesRepository];

            //var areaRepository = _configuration["AreaRepository:" + RepositoryName];

            var folder = Path.Combine(templatesRepository, RepositoryName);

            var file = Path.Combine(folder, FileName);

            return file.ToString().Trim();
        }

    }
}