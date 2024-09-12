using TCMPLAPP.WinService.Models;
using TCMPLAPP.WinService.Services;

namespace TCMPLAPP.WinService.Areas
{
    public class Attendance : IAttendance
    {
        ILogger<IAttendance> _logger;
        IHttpClientTCMPLAppWebApi _httpClientTCMPLAppWebApi;

        IConfiguration _configuration;
        private readonly IProcessDBLogger _processDBLogger;

        private static string ModuleAttendance = "M04";
        protected static string UriPunchDataUpload = "AttendanceProcesses/UploadPunchData";
        protected static string UriEmpRFIDDataUpload = "AttendanceProcesses/UploadEmpRfidData";
        protected static string ProcessIdPunchUpload = "PUNCHUPLOD";
        protected static string ProcessIdEmpCardRFIDUpload = "EMPRFIDUPD";

        //private readonly static string TasFileDirectory = @"\\tplhratt01\\TextFile";
        //private readonly static string EmpCardRFIDFileDirectory = @"\\tplhratt01\\TextFile\\EMP_CARD_RFID";

        public Attendance(ILogger<IAttendance> logger, IHttpClientTCMPLAppWebApi httpClientTCMPLAppWebApi, IConfiguration configuration, IProcessDBLogger processDBLogger)
        {
            _logger = logger;
            _httpClientTCMPLAppWebApi = httpClientTCMPLAppWebApi;
            _configuration = configuration;
            _processDBLogger = processDBLogger;

        }

        public WSMessageModel ExecuteProcess(ProcessQueueModel currProcess)
        {
            if (currProcess.ModuleId == ModuleAttendance && currProcess.ProcessId == ProcessIdPunchUpload)
            {
                return PunchDataUpload(currProcess);
            }
            else if (currProcess.ModuleId == ModuleAttendance && currProcess.ProcessId == ProcessIdEmpCardRFIDUpload)
            {
                return EmpCardRFIDDataUpload(currProcess);
            }

            return new WSMessageModel { Status = "KO", Message = "Attendance - Corresponding method not found" };
        }

        public WSMessageModel PunchDataUpload(ProcessQueueModel currProcess)
        {
            bool hasErrors = false;
            int fileModifiedHours = -14;
            string tasFileDirectory = _configuration.GetValue<string>("TasFileDirectory");
            DirectoryInfo di = new DirectoryInfo(tasFileDirectory);
            var files = di.GetFiles().Where(f => f.LastWriteTime >= DateTime.Now.AddHours(fileModifiedHours) && f.Extension.ToUpper().StartsWith(".TAS"));

            if (files.Count() == 0)
            {
                return new WSMessageModel { Status = "OK", Message = "No files to upload" };
            }
            else
            {
                _processDBLogger.LogInformation(new HCModel { KeyId = currProcess.KeyId, LogMessage = String.Format("{0} - files to be processed.", files.Count()) });
            }
            foreach (var file in files)
            {
                _processDBLogger.LogInformation(new HCModel { KeyId = currProcess.KeyId, LogMessage = String.Format("{0} - File being processed", file.Name) });
                var uriHttpResponse = Task.Run(async () => await _httpClientTCMPLAppWebApi.PostFileUriAsync(null, file, UriPunchDataUpload)).Result;

                var retObj = HttpResponseHelper.ConvertResponseMessageToObject<WSMessageModel>(uriHttpResponse);

                if (retObj.Status == "OK")
                    _processDBLogger.LogInformation(new HCModel { KeyId = currProcess.KeyId, LogMessage = file.Name + " - Successfully processed" });
                else
                {
                    _processDBLogger.LogError(new HCModel { KeyId = currProcess.KeyId, LogMessage = file.Name + " - ERROR processing" });
                    hasErrors = true;
                }
            }
            return new WSMessageModel { Status = hasErrors ? "KO" : "OK", Message = hasErrors ? "Error(s) while uploading punch data" : "Punch data uploaded successfully." };
        }

        public WSMessageModel EmpCardRFIDDataUpload(ProcessQueueModel currProcess)
        {
            bool hasErrors = false;

            string empCardRFIDFileDirectory = _configuration.GetValue<string>("EmpCardRFIDFileDirectory");

            if (File.Exists(Path.Combine(empCardRFIDFileDirectory, "File1.txt")) == false)
            {
                _processDBLogger.LogInformation(new HCModel { KeyId = currProcess.KeyId, LogMessage = "Err - File not found." });
                return new WSMessageModel { Status = "KO", Message = "Error(s) while uploading EMP RFID data" };

            }

            DirectoryInfo di = new DirectoryInfo(empCardRFIDFileDirectory);
            var file = di.GetFiles().Where(f => f.Name == "File1.txt").FirstOrDefault();
            _processDBLogger.LogInformation(new HCModel { KeyId = currProcess.KeyId, LogMessage = String.Format("{0} - File being processed", file.Name) });

            var uriHttpResponse = Task.Run(async () => await _httpClientTCMPLAppWebApi.PostFileUriAsync(null, file, UriEmpRFIDDataUpload)).Result;

            var retObj = HttpResponseHelper.ConvertResponseMessageToObject<WSMessageModel>(uriHttpResponse);

            if (retObj.Status == "OK")
                _processDBLogger.LogInformation(new HCModel { KeyId = currProcess.KeyId, LogMessage = file.Name + " - Successfully processed" });
            else
            {
                _processDBLogger.LogError(new HCModel { KeyId = currProcess.KeyId, LogMessage = file.Name + " - ERROR processing" });
                hasErrors = true;
            }
            //}
            return new WSMessageModel { Status = hasErrors ? "KO" : "OK", Message = hasErrors ? "Error(s) while uploading EMP RFID data" : "EMP RFID uploaded successfully." };

        }

    }
}