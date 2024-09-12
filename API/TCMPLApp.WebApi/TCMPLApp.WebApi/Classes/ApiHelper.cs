using System.Text;
using TCMPLApp.WebApi.Models;

namespace TCMPLApp.WebApi.Classes
{
    public  class ApiHelper
    {
        public ResponseModel ConvertToSuccessResponse<Tin>(Tin tin) where Tin : class, new()  
        {
            //var oResponseBody = new ResponseModel { Status = "OK", Data = tin };
            //return oResponseBody; 
            return new ResponseModel();
        }

        private static readonly string ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
        "abcdefghijklmnopqrstuvwxyz" +
        "0123456789";

        public static string generateText(int length)
        {
            Random random = new Random();
            StringBuilder builder = new StringBuilder(length);

            for (int i = 0; i < length; ++i)
            {
                int index = random.Next(ALPHABET.Length);

                builder.Append(ALPHABET[index]);
            }

            return builder.ToString();
        }
    }
}

