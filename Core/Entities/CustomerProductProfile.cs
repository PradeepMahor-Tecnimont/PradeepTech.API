namespace Core.Entities
{
    public class CustomerProductProfile : BaseEntity
    {
        public string CustomerID { get; set; } = string.Empty;

        public string CustomerName { get; set; } = string.Empty;

        public string Status { get; set; } = string.Empty;

        public string SupervisorName { get; set; } = string.Empty;

        public string Contact1 { get; set; } = string.Empty;

        public string Contact2 { get; set; } = string.Empty;

        public DateTime? ValidEndDate { get; set; }

        public string Email1 { get; set; } = string.Empty;

        public string Email2 { get; set; } = string.Empty;

        public string CustomerGST { get; set; } = string.Empty;

        public string CustomerAddress { get; set; } = string.Empty;

        public DateTime? ValidFromDate { get; set; }

        public DateTime? ValidToDate { get; set; }

        public string CountryCode { get; set; } = string.Empty;

        public string ContactNo { get; set; } = string.Empty;
    }
}