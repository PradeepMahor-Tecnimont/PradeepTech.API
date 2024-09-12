using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace TCMPLApp.WebApp.Models
{
        public class ImportFileResultViewModel
        {
            [JsonPropertyName("id")]
            public int Id { get; set; }

            [JsonPropertyName("section")]
            [Display(Name = "Section")]
            public string Section { get; set; }

            [JsonPropertyName("excelRowNumber")]
            [Display(Name = "Excel row number")]
            public int? ExcelRowNumber { get; set; }

            [JsonPropertyName("fieldName")]
            [Display(Name = "Field name")]
            public string FieldName { get; set; }

            [JsonPropertyName("errorType")]
            [Display(Name = "Error type")]
            public ImportFileValidationErrorTypeEnum ErrorType { get; set; }

            [JsonPropertyName("errorTypeString")]
            [Display(Name = "Error type")]
            public string ErrorTypeString { get; set; }

            [JsonPropertyName("message")]
            [Display(Name = "Message")]
            public string Message { get; set; }
        }

        public enum ImportFileValidationErrorTypeEnum
        {
            Critical,
            Warning,
            Success
        }

    
}
