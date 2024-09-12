namespace TCMPLApp.WebApp.Models
{
    public class ShiftDataTableListExcel
    {
        public string Shiftcode { get; set; }
        public string Shiftdesc { get; set; }
        public decimal TimeinHh { get; set; }
        public decimal TimeinMn { get; set; }
        public decimal TimeoutHh { get; set; }
        public decimal TimeoutMn { get; set; }
        public string Shift4allowanceText { get; set; }
        public decimal LunchMn { get; set; }
        public string OtApplicableText { get; set; }
    }
}
