namespace Core.Entities
{
    public class UsersClient : BaseEntity
    {
        public string UserId { get; set; } = string.Empty;

        public string FirstName { get; set; } = string.Empty;

        public string LastName { get; set; } = string.Empty;

        public string UserName { get; set; } = string.Empty;

        public string ParentOrg { get; set; } = string.Empty;

        public string UserType { get; set; } = string.Empty;

        public string SupervisorName { get; set; } = string.Empty;

        public string AdminName { get; set; } = string.Empty;

        public string ContactNo { get; set; } = string.Empty;

        public string EmailId { get; set; } = string.Empty;

        public DateTime? ValidFromDate { get; set; }

        public DateTime? ValidToDate { get; set; }

        public string UploadProfilePic { get; set; } = string.Empty;

        public string ActiveStatus { get; set; } = string.Empty;
    }
}