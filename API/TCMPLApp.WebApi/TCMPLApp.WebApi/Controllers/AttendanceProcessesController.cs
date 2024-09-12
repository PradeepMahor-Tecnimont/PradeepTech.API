using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MimeTypes;
using System.Net;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.WebApi.Classes;
using TCMPLApp.WebApi.Models;

namespace TCMPLApp.WebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class AttendanceProcessesController : BaseController<AttendanceProcessesController>
    {
        private readonly IAttendancePunchUploadRepository _attendancePunchUploadRepository;
        private readonly IAttendanceEmpCardRFIDUploadRepository _attendanceEmpCardRFIDUploadRepository;

        public AttendanceProcessesController(IAttendancePunchUploadRepository attendancePunchUploadRepository, IAttendanceEmpCardRFIDUploadRepository attendanceEmpCardRFIDUploadRepository)
        {
            _attendancePunchUploadRepository = attendancePunchUploadRepository;
            _attendanceEmpCardRFIDUploadRepository = attendanceEmpCardRFIDUploadRepository;
        }

        [Route("UploadPunchData")]
        [HttpPost]
        public async Task<ActionResult> UploadPunchData(IFormFile file)
        {


            try
            {
                if (file == null || file.Length == 0)
                    return StatusCode((int)HttpStatusCode.InternalServerError, "File not uploaded due to an error");


                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();

                //byte[] fileBytes = System.IO.File.ReadAllBytes()

                byte[] byteArray;
                using (var ms = new MemoryStream())
                {
                    file.CopyTo(ms);
                    byteArray = ms.ToArray();
                }
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.ToLower().Contains("tas"))
                    return StatusCode((int)HttpStatusCode.InternalServerError, new { Status = "KO", Message = "Tas file not recognized" });


                // Try to convert stream to a class

                var result = await _attendancePunchUploadRepository.UploadPunchDataAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PBlob = byteArray,
                        PClintFileName = fileName
                    }
                    );
                return Ok(new ResponseModel { Status = result.PMessageType, Message = result.PMessageText });
                // Call database json stored procedure


            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, new ResponseModel { Status = "KO", Message = ex.Message });
            }
        }

        [Route("UploadEmpRfidData")]
        [HttpPost]
        public async Task<ActionResult> UploadEmpRfidData(IFormFile file)
        {


            try
            {
                if (file == null || file.Length == 0)
                    return StatusCode((int)HttpStatusCode.InternalServerError, "File not uploaded due to an error");


                FileInfo fileInfo = new FileInfo(file.FileName);

                Guid storageId = Guid.NewGuid();

                //byte[] fileBytes = System.IO.File.ReadAllBytes()

                byte[] byteArray;
                using (var ms = new MemoryStream())
                {
                    file.CopyTo(ms);
                    byteArray = ms.ToArray();
                }
                var fileName = file.FileName;
                var fileSize = file.Length;
                var mimeType = MimeTypeMap.GetMimeType(fileInfo.Extension);

                // Check file validation
                if (!fileInfo.Extension.ToLower().Contains("txt"))
                    return StatusCode((int)HttpStatusCode.InternalServerError, new { Status = "KO", Message = "Tas file not recognized" });


                // Try to convert stream to a class

                var result = await _attendanceEmpCardRFIDUploadRepository.UploadEmpCardRFIDDataAsync(BaseSpTcmPLGet(),
                    new ParameterSpTcmPL
                    {
                        PBlob = byteArray
                    }
                    );
                return Ok(new ResponseModel { Status = result.PMessageType, Message = result.PMessageText });
                // Call database json stored procedure


            }
            catch (Exception ex)
            {
                return StatusCode((int)HttpStatusCode.InternalServerError, new ResponseModel { Status = "KO", Message = ex.Message });
            }
        }

    }
}
