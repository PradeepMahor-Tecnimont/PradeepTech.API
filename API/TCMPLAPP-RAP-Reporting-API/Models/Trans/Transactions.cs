using RapReportingApi.RAPEntityModels;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace RapReportingApi.Models.Trans
{
    /// <summary>
    /// Costcode wise count of work force
    /// </summary>
    public class NumOfEmp
    {
        [Key]
        public string Costcode { get; set; }

        public int? Noofemps { get; set; }
        public long? Changednemps { get; set; }
    }

    /// <summary>
    /// Change Approver of costcode
    /// </summary>
    public class ModApprover
    {
        [Key]
        public string Costcode { get; set; }

        public string Dyhod { get; set; }
    }

    /// <summary>
    /// OverTime Required
    /// </summary>

    /// <summary>
    /// Workforce Movement
    /// </summary>
    public class WFMovement
    {
        [Key]
        public string Costcode { get; set; }

        [Key]
        public string Yymm { get; set; }

        //public List<Movemast> addMovemast { get; set; }
        //public List<Movemast> editMovemast { get; set; }
        //public List<Movemast> deleteMovemast { get; set; }
    }

    /// <summary>
    /// Project wise activity
    /// </summary>
    //public class ProjActivity
    //{
    //    [Key]
    //    public string Projno { get; set; }

    //    [Key]
    //    public string Costcode { get; set; }

    //    //[Key]
    //    //public string Activity { get; set; }
    //    public List<ProjactMast> addProjact { get; set; }

    //    public List<ProjactMast> editProjact { get; set; }
    //    public List<ProjactMast> deleteProjact { get; set; }
    //}

    /// <summary>
    /// Projections - Expected Project
    /// </summary>
    public class ExpProjections
    {
        [Key]
        public string Projno { get; set; }

        [Key]
        public string Costcode { get; set; }

    }

    /// <summary>
    /// Expected Jobs Master
    /// </summary>
    public class ExpectedJobs
    {
        [Key]
        public string Projno { get; set; }

        public string Name { get; set; }
        public short? Active { get; set; }
        public short? Activefuture { get; set; }
        public string Projtype { get; set; }
        public decimal? Hrs { get; set; }
    }
}