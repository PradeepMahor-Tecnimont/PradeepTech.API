using System;

namespace TCMPLApp.Library.Excel.Template.Models
{
    public class EmpAssetMovement
    {
        public string Empno { get; set; }       
        public string CurrentDesk{ get; set; }
        public string TargetDesk{ get; set; }
        public string MoveAssets{ get; set; }
        public string MoveEmployee{ get; set; }

    }
}