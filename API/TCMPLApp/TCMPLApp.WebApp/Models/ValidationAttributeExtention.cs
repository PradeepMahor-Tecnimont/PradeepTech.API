using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class ValidateVaccineDatesSecondJab : ValidationAttribute
    {
        protected override ValidationResult
                IsValid(object value, ValidationContext validationContext)
        {
            var model = (VaccinationSelfCreateViewModel)validationContext.ObjectInstance;

            if (model.SecondJab == null)
            {
                return ValidationResult.Success;
            }
            else if (DateTime.Compare((DateTime)model.FirstJab, (DateTime)model.SecondJab) >= 0)
            {
                return new ValidationResult("Second Jab Date should be greater than First Jab");
            }
            else if (DateTime.Compare((DateTime)model.SecondJab, DateTime.Now) >= 0)
            {
                return new ValidationResult("Second Jab Date should blank or it should be in the past.");
            }
            else return ValidationResult.Success;

        }
    }

    public class ValidateVaccineDatesFirstJab : ValidationAttribute
    {
        protected override ValidationResult
                IsValid(object value, ValidationContext validationContext)
        {
            var model = (VaccinationSelfCreateViewModel)validationContext.ObjectInstance;
            if (DateTime.Compare((DateTime)model.FirstJab, DateTime.Now) >= 0)
            {
                return new ValidationResult("First Jab Date should be in the past.");
            }
            else return ValidationResult.Success;

        }
    }

    public class ValidateVaccineDatesEdit : ValidationAttribute
    {
        protected override ValidationResult
                IsValid(object value, ValidationContext validationContext)
        {
            var model = (VaccineSelfEditViewModel)validationContext.ObjectInstance;

            if (model.SecondJab == null) return ValidationResult.Success;

            if (DateTime.Compare(model.FirstJab, (DateTime)model.SecondJab) >= 0)
            {
                return new ValidationResult("Second Jab Date should be greater than First Jab");
            }
            else if (DateTime.Compare((DateTime)model.SecondJab, DateTime.Now) >= 0)
            {
                return new ValidationResult("Second Jab Date should not be a future date");
            }
            else return ValidationResult.Success;

        }
    }


    public class RequiredIfAttribute : ValidationAttribute
    {
        public string _compareWithProperty { get; set; }
        public object _compareWithValue { get; set; }

        public RequiredIfAttribute(string propertyName, object compareWithValue, string errorMessage = "")
        {
            _compareWithProperty = propertyName;
            ErrorMessage = errorMessage;
            _compareWithValue = compareWithValue;
        }

        public RequiredIfAttribute(string propertyName, string errorMessage = "")
        {
            _compareWithProperty = propertyName;
            ErrorMessage = errorMessage;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var compareWithPropertyValue = validationContext.ObjectInstance.GetType().GetProperty(_compareWithProperty).GetValue(validationContext.ObjectInstance, null);

            if (_compareWithValue == null)
            {
                if (compareWithPropertyValue != null && value == null)
                    return new ValidationResult(ErrorMessage);
            }
            else
            {
                if (compareWithPropertyValue.ToString() == _compareWithValue.ToString() && value == null)
                    return new ValidationResult(ErrorMessage);
            }
            return ValidationResult.Success;
        }
    }

    public class MaxFileSizeAttribute : ValidationAttribute
    {
        private readonly int _maxFileSize;
        public MaxFileSizeAttribute(int maxFileSize)
        {
            _maxFileSize = maxFileSize;
        }

        protected override ValidationResult IsValid(
        object value, ValidationContext validationContext)
        {
            var file = value as IFormFile;
            if (file != null)
            {
                if (file.Length > _maxFileSize)
                {
                    return new ValidationResult(GetErrorMessage());
                }
            }

            return ValidationResult.Success;
        }

        public string GetErrorMessage()
        {
            return $"Maximum allowed file size is { _maxFileSize} MB.";
        }
    }

    public class AllowedExtensionsAttribute : ValidationAttribute
    {
        private readonly string[] _extensions;
        public AllowedExtensionsAttribute(string[] extensions)
        {
            _extensions = extensions;
        }

        protected override ValidationResult IsValid(
        object value, ValidationContext validationContext)
        {
            var file = value as IFormFile;
            if (file != null)
            {
                var extension = Path.GetExtension(file.FileName);
                if (!_extensions.Contains(extension.ToLower()))
                {
                    return new ValidationResult(GetErrorMessage());
                }
            }

            return ValidationResult.Success;
        }

        public string GetErrorMessage()
        {
            string extensions = string.Join(",", _extensions);
            return string.Format("Only {0} files are allowed!", extensions);
        }
    }

    public class DateGreaterThanAttribute : ValidationAttribute
    {
        string _compareWithDateTimeProperty;
        public DateGreaterThanAttribute(string compareWithDateTimeProperty, string errorMessage)
        {
            _compareWithDateTimeProperty = compareWithDateTimeProperty;
            ErrorMessage = errorMessage;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (value == null)
                return ValidationResult.Success;

            var instanceDateTime = (DateTime)value;

            DateTime valueToCompare = (DateTime)validationContext.ObjectInstance.GetType().GetProperty(_compareWithDateTimeProperty).GetValue(validationContext.ObjectInstance, null);

            if (instanceDateTime.Date <= valueToCompare.Date)
            {
                return new ValidationResult(ErrorMessage);
            }
            return ValidationResult.Success;

        }
    }

    public class DateLessThanAttribute : ValidationAttribute
    {

        string _compareWithDateTimeProperty;

        public DateLessThanAttribute(string compareWithDateTimeProperty, string errorMessage)
        {
            _compareWithDateTimeProperty = compareWithDateTimeProperty;
            ErrorMessage = errorMessage;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (value == null)
                return ValidationResult.Success;

            var instanceDateTime = (DateTime)value;

            DateTime valueToCompare = (DateTime)validationContext.ObjectInstance.GetType().GetProperty(_compareWithDateTimeProperty).GetValue(validationContext.ObjectInstance, null);

            if (instanceDateTime.Date >= valueToCompare.Date)
            {
                return new ValidationResult(ErrorMessage);
            }
            return ValidationResult.Success;

        }

    }


    public class DateGreaterThanTodayAttribute : ValidationAttribute
    {
        public DateGreaterThanTodayAttribute(string errorMessage)
        {
            ErrorMessage = errorMessage;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (value == null)
                return ValidationResult.Success;

            var instanceDateTime = (DateTime)value;

            DateTime valueToCompare = DateTime.Now;

            if (instanceDateTime.Date <= valueToCompare.Date)
            {
                return new ValidationResult(ErrorMessage);
            }
            return ValidationResult.Success;

        }
    }

    public class DateLessThanTodayAttribute : ValidationAttribute
    {

        public DateLessThanTodayAttribute(string errorMessage)
        {
            ErrorMessage = errorMessage;
        }

        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            if (value == null)
                return ValidationResult.Success;

            var instanceDateTime = (DateTime)value;

            DateTime valueToCompare = DateTime.Now;

            if (instanceDateTime.Date >= valueToCompare.Date)
            {
                return new ValidationResult(ErrorMessage);
            }
            return ValidationResult.Success;

        }

    }


}
