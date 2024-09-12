using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.Domain.Models.DigiForm
{
    public class MidEvaluationDetail : DBProcMessageOutput
    {
        public string PEmpno { get; set; }
        public string PDesgcode { get; set; }
        public string PParent { get; set; }
        public string PAttendance { get; set; }
        public string PLocation { get; set; }
        public string PSkill1 { get; set; }
        public decimal? PSkill1RatingVal { get; set; }
        public string PSkill1RatingText { get; set; }
        public string PSkill1Remark { get; set; }
        public string PSkill2 { get; set; }
        public decimal? PSkill2RatingVal { get; set; }
        public string PSkill2RatingText { get; set; }
        public string PSkill2Remark { get; set; }
        public string PSkill3 { get; set; }
        public decimal? PSkill3RatingVal { get; set; }
        public string PSkill3RatingText { get; set; }
        public string PSkill3Remark { get; set; }
        public string PSkill4 { get; set; }
        public decimal? PSkill4RatingVal { get; set; }
        public string PSkill4RatingText { get; set; }
        public string PSkill4Remark { get; set; }
        public string PSkill5 { get; set; }
        public decimal? PSkill5RatingVal { get; set; }
        public string PSkill5RatingText { get; set; }
        public string PSkill5Remark { get; set; }
        public decimal? PQue2RatingVal { get; set; }
        public string PQue2RatingText { get; set; }
        public string PQue2Remark { get; set; }
        public decimal? PQue3RatingVal { get; set; }
        public string PQue3RatingText { get; set; }
        public string PQue3Remark { get; set; }
        public decimal? PQue4RatingVal { get; set; }
        public string PQue4RatingText { get; set; }
        public string PQue4Remark { get; set; }
        public decimal? PQue5RatingVal { get; set; }
        public string PQue5RatingText { get; set; }
        public string PQue5Remark { get; set; }
        public decimal? PQue6RatingVal { get; set; }
        public string PQue6RatingText { get; set; }
        public string PQue6Remark { get; set; }
        public string PObservations { get; set; }
        public string PCreatedBy { get; set; }
        public string PCreatedOn { get; set; }
        public string PModifiedBy { get; set; }
        public string PModifiedOn { get; set; }
        public string PIsdeleted { get; set; }
        public string PHodApproval { get; set; }
        public string PHodApprovalDate { get; set; }
    }
}