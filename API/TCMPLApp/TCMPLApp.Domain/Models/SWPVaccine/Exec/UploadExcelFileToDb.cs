using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class UploadExcelFileToDb
    {
        private string _commandText = SWPVaccineProcedures.UploadExcelFile;

        public string CommandText { get => _commandText; set => _commandText = value; }
        public byte[] PBlob { get; set; }
        //public string OutPBlobId { get; set; }
        public string OutPSuccess { get; set; }
        public string OutPMessage { get; set; }

    }
}
