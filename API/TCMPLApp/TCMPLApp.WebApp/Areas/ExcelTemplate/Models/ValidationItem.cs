
namespace TCMPLApp.WebApp.Areas.ExcelTemplate.Models
{
    public class ValidationItem
    {
        public int Id { get; set; }

        public string Section { get; set; }

        public int ExcelRowNumber { get; set; }

        public string FieldName { get; set; }

        public ValidationItemErrorTypeEnum ErrorType { get; set; }

        public string Message { get; set; }
    }

    public enum ValidationItemErrorTypeEnum
    {
        Critical,
        Warning
    }
}
