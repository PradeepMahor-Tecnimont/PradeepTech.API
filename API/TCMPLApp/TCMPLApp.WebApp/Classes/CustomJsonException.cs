using System.Runtime.Serialization;
using System;

namespace TCMPLApp.WebApp.Classes
{

    [Serializable]
    public class CustomJsonException : Exception
    {
        public CustomJsonException()
        : base() { }

        public CustomJsonException(string message)
            : base(message) { }

        public CustomJsonException(string format, params object[] args)
            : base(string.Format(format, args)) { }

        public CustomJsonException(string message, Exception innerException)
            : base(message, innerException) { }

        public CustomJsonException(string format, Exception innerException, params object[] args)
            : base(string.Format(format, args), innerException) { }

        protected CustomJsonException(SerializationInfo info, StreamingContext context)
        : base(info, context) { }
    }
}
#region Examples
//throw new CustomJsonException();
//throw new CustomJsonException(message);
//throw new CustomJsonException("Exception with parameter value '{0}'", param);
//throw new CustomJsonException(message, innerException);
//throw new CustomJsonException("Exception with parameter value '{0}'", innerException, param); // param always floating
#endregion

