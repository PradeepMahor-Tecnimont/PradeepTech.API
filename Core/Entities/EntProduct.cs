namespace Core.Entities
{
    public class EntProduct : BaseEntity
    {
        public string ProductCode { get; set; } = string.Empty;

        public string ProductName { get; set; } = string.Empty;

        public DateTime? ServiceDate { get; set; }

        public DateTime? WarrantyDate { get; set; }

        public string ProductDescription { get; set; } = string.Empty;

        public string UploadPhoto { get; set; } = string.Empty;

        public string Status { get; set; } = string.Empty;
    }
}