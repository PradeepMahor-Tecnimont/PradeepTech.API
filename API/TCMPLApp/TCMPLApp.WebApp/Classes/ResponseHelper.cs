using Microsoft.AspNetCore.Mvc;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Classes
{

    public static class ResponseHelper
    {

        private static readonly string[] messageTypeText = { "KO", "OK", "OO" };

        public static dynamic GetMessageObject(string Message, NotificationType MessageType = NotificationType.success)
        {
            return new
            {
                MessageType = messageTypeText[(int)MessageType],
                MessageText = Message
            };

        }

        public static dynamic GetMessageObject<T>(string Message, T t1, NotificationType MessageType = NotificationType.success)
        {
            return new
            {
                MessageType = messageTypeText[(int)MessageType],
                MessageText = Message,
                MessageData = t1
            };
        }

        public static dynamic GetMessageObject(string Message, FileContentResult FileContentResult, NotificationType MessageType = NotificationType.success)
        {
            return new
            {
                MessageType = messageTypeText[(int)MessageType],
                MessageText = Message,
                MessageFileContent = FileContentResult
            };
        }

        public static dynamic GetMessageObject<T>(string Message, T t1, FileContentResult FileContentResult, NotificationType MessageType = NotificationType.success)
        {
            return new
            {
                MessageType = messageTypeText[(int)MessageType],
                MessageText = Message,
                MessageData = t1,
                MessageFileContent = FileContentResult
            };
        }
    }
}
