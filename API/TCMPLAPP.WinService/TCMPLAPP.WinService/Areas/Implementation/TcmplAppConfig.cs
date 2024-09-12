using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.WinService.Models;
using TCMPLAPP.WinService.Services;

namespace TCMPLAPP.WinService.Areas
{
    public class TcmplAppConfig : ITcmplAppConfig
    {
        private readonly ILogger<ITcmplAppConfig> _logger;
        private readonly IHttpClientTCMPLAppWebApi _httpClientTCMPLAppWebApi;
        private readonly IConfiguration _configuration;
        private readonly IProcessDBLogger _processDBLogger;

        private static readonly string moduleTcmplAppConfig = "M13";
        public string logDirectoryPath;
        string[] directories = new string[]
        {
            "WinService",
            "WebApi",
            "WebApp",
            "RapReporting"
        };
        public TcmplAppConfig(ILogger<ITcmplAppConfig> logger,
                          IHttpClientTCMPLAppWebApi httpClientTCMPLAppWebApi,
                          IConfiguration configuration,
                          IProcessDBLogger processDBLogger)
        {
            _logger = logger;
            _httpClientTCMPLAppWebApi = httpClientTCMPLAppWebApi;
            _configuration = configuration;
            _processDBLogger = processDBLogger;
        }

        public WSMessageModel ExecuteProcess(ProcessQueueModel processQueueModel)
        {
            if (processQueueModel.ModuleId == moduleTcmplAppConfig)
            {
                if (processQueueModel.ProcessId == "TcmplAppLogCleaner")
                {
                    IConfiguration configuration = _configuration;

                    string logDir = _configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];

                    string downloadDir = _configuration.GetSection("TCMPLAppDownloadRepository").Value?.ToString();

                    string tempDir = _configuration.GetSection("TCMPLAppTempRepository").Value?.ToString();
                    
                    return logFileCleaner(logDir, downloadDir,tempDir);
                }
            }

            return new WSMessageModel { Status = "KO", Message = "TcmplAppLogCleaner - Method not found" };
        }

        protected WSMessageModel logFileCleaner(string logDir,string downloadDir,string tempDir)
        {
            int logRetentionDays = Convert.ToInt32(_configuration.GetSection("TCMPLAppLogRetentionDays").Value);

            CleanLogDirectories(logDir, logRetentionDays);

            CleanDirectory(downloadDir, logRetentionDays);

            CleanDirectory(tempDir, logRetentionDays);

            return new WSMessageModel { Status = "OK", Message = "Log File Clean Successfully" };
        }

        private void CleanLogDirectories(string logDir, int logRetentionDays)
        {
            foreach (string directory in directories)
            {
                string directoryPath = _configuration.GetSection("TCMPLAppLogDirs")[directory];
                _logger.LogInformation($"{DateTime.Now} Directory Path: {directoryPath}");

                string logDirectoryPath = Path.Combine(logDir, directoryPath);
                _logger.LogInformation($"{DateTime.Now} Log Directory Path: {logDirectoryPath}");

                var files = Directory.GetFiles(logDirectoryPath);
                foreach (var file in files)
                {
                    var fileInfo = new FileInfo(file);
                    _logger.LogInformation($"{DateTime.Now} File Information: {fileInfo}");
                    
                    if ((DateTime.Now - fileInfo.CreationTime).TotalDays > logRetentionDays)
                    {
                        fileInfo.Delete();
                        _logger.LogInformation($"{DateTime.Now}: File Delete Successfully.");
                    }
                }
            }
        }

        private void CleanDirectory(string folderPath, int logRetentionDays)
        {
            try
            {
                // Delete files in the current directory
                var files = Directory.GetFiles(folderPath);
                foreach (var file in files)
                {
                    var fileInfo = new FileInfo(file);
                    if ((DateTime.Now - fileInfo.CreationTime).TotalDays > logRetentionDays)
                    {
                        fileInfo.Delete();
                        _logger.LogInformation($"{DateTime.Now}: Deleted file {fileInfo.FullName} successfully.");
                    }
                }
                
                // clean subdirectories
                var directories = Directory.GetDirectories(folderPath);
                foreach (var directory in directories)
                {
                    CleanDirectory(directory, logRetentionDays);

                    if (Directory.GetFiles(directory).Length == 0 && Directory.GetDirectories(directory).Length == 0)
                    {
                        var dirInfo = new DirectoryInfo(directory);
                        if ((DateTime.Now - dirInfo.CreationTime).TotalDays > logRetentionDays)
                        {
                            dirInfo.Delete();
                            _logger.LogInformation($"{DateTime.Now}: Deleted directory {dirInfo.FullName} successfully.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"{DateTime.Now} Error while cleaning directory {folderPath}: {ex.Message}");
            }
        }
    }
}
