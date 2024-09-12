using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;
using System;
using System.ComponentModel;

namespace TCMPLApp.WebApp.Models
{
    public class ProspectiveEmployeesUpdateViewModel
    {
        [Required]
        [StringLength(8)]
        public string KeyId { get; set; }

        [Required]
        [Display(Name = "Department")]
        public string Costcode { get; set; }

        [Required]
        [StringLength(100)]
        [Display(Name = "Prospective Employee")]
        public string EmpName { get; set; }

        [Required]
        [Display(Name = "Office Location")]
        public string OfficeLocationCode { get; set; }

        [Required]
        [Display(Name = "Proposed DOJ")]
        public DateTime? ProposedDoj { get; set; }

        [Display(Name = "Revised DOJ")]
        public DateTime? RevisedDoj { get; set; }

        [Required]
        [Display(Name = "Status")]
        public string JoinStatusCode { get; set; }

        [Display(Name = "Joined as")]
        public string Empno { get; set; }

        [Display(Name = "Grade")]
        public string Grade { get; set; }

        [Display(Name = "Designation")]
        public string Designation { get; set; }

        [Display(Name = "Employment Type")]
        public string EmploymentType { get; set; }

        [Display(Name = "Sources of Candidate")]
        public string SourcesOfCandidate { get; set; }

        [Display(Name = "Pre Employment Medical Test")]
        public string PreEmploymentMedicalTest { get; set; }

        [Display(Name = "Recommendation for Appointment")]
        public string RecommendationForAppointment { get; set; }

        [Display(Name = "Offer letter")]
        public string OfferLetter { get; set; }

        [Display(Name = "Medical Request Date")]
        public DateTime? MedicalRequestDate { get; set; }

        [Display(Name = "Actual Appointment Date")]
        public DateTime? ActualAppointmentDate { get; set; }

        [Display(Name = "Medical Fitness Certificate")]
        public DateTime? MedicalFitnessCertificate { get; set; }

        [Display(Name = "Recommendation Issued")]
        public DateTime? RecommendationIssued { get; set; }

        [Display(Name = "Recommendation Received")]
        public DateTime? RecommendationReceived { get; set; }

        [StringLength(150)]
        [Display(Name = "Remark (Pre Employment Medical Test)")]
        public string RemarkPreEmploymentMedicalTest { get; set; }

        [StringLength(150)]
        [Display(Name = "Remark (Recommendation for Appointment)")]
        public string RemarkRecommendationForAppointment { get; set; }
    }
}