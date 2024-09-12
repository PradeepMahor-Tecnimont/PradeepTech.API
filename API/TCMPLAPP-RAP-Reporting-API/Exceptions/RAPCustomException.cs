namespace RapReportingApi.Exceptions
{
    public class RAPCustomException : System.Exception
    {
        private readonly string _code;

        public RAPCustomException(string message, string code) : base(message)
        {
            _code = code;
        }

        #region This is for remove warnings from RAPCustomException

        public RAPCustomException() : base()
        {
        }

        public RAPCustomException(string message) : base(message)
        {
        }

        public RAPCustomException(string message, System.Exception innerException) : base(message, innerException)
        {
        }

        #endregion This is for remove warnings from RAPCustomException

        public string RAPErrorCode
        {
            get => _code;
        }
    }

    public class RAPInvalidParameter : RAPCustomException
    {
        public RAPInvalidParameter(string message) : base(message, "INVALID_PARAMS")
        {
        }

        #region This is for remove warnings from RAPInvalidParameter

        public RAPInvalidParameter(string message, string code) : base(message, code)
        {
        }

        public RAPInvalidParameter() : base()
        {
        }

        public RAPInvalidParameter(string message, System.Exception innerException) : base(message, innerException)
        {
        }

        #endregion This is for remove warnings from RAPInvalidParameter
    }

    public class RAPDBException : RAPCustomException
    {
        public RAPDBException(string message) : base(message, "DB_ERROR")
        {
        }

        public RAPDBException(string message, string code) : base(message, code)
        {
        }

        #region This is for remove warnings from RAPDBException

        public RAPDBException() : base()
        {
        }

        public RAPDBException(string message, System.Exception innerException) : base(message, innerException)
        {
        }

        #endregion This is for remove warnings from RAPDBException
    }

    public class RAPDBValidation : RAPCustomException
    {
        public RAPDBValidation(string message) : base(message, "DB_Validation")
        {
        }

        public RAPDBValidation(string message, string code) : base(message, code)
        {
        }

        #region This is for remove warnings from RAPDBValidation

        public RAPDBValidation() : base()
        {
        }

        public RAPDBValidation(string message, System.Exception innerException) : base(message, innerException)
        {
        }

        #endregion This is for remove warnings from RAPDBValidation
    }

    public class RAPDataNotFound : RAPCustomException
    {
        public RAPDataNotFound(string message) : base(message, "NO_DATA_FOUND")
        {
        }

        #region This is for remove warnings from RAPDataNotFound

        public RAPDataNotFound(string message, string code) : base(message, code)
        {
        }

        public RAPDataNotFound() : base()
        {
        }

        public RAPDataNotFound(string message, System.Exception innerException) : base(message, innerException)
        {
        }

        #endregion This is for remove warnings from RAPDataNotFound
    }
}