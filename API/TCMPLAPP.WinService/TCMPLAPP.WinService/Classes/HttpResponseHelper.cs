using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.WinService.Models;

namespace TCMPLAPP.WinService
{
    public static class HttpResponseHelper
    {
        static HttpResponseHelper()
        {

        }

        public static WSMessageExtensionModel<T> ConvertResponseMessageToObject<T>(HttpResponseMessage httpResponseMessage) where T : class
        {
            WSMessageExtensionModel<T> retMessage = new WSMessageExtensionModel<T>();

            if (httpResponseMessage.StatusCode != System.Net.HttpStatusCode.OK)
            {
                retMessage.Message = httpResponseMessage.Content.ReadAsStringAsync().Result.ToString();
                retMessage.Message = JsonConvert.DeserializeObject(retMessage.Message).ToString();
                retMessage.Status = "KO";
                return retMessage;
            }

            retMessage.Status = "OK";

            if (httpResponseMessage.Content.Headers.ContentType.MediaType == "application/json")
            {
                var jsonResult = httpResponseMessage.Content.ReadAsStringAsync().Result;

                var result = JsonConvert.DeserializeObject(jsonResult);
                retMessage.Data = JsonConvert.DeserializeObject<T>(result.ToString());
                return retMessage;
            }
            else
            {
                if (typeof(T) == typeof(Byte[]))
                    retMessage.Data = (T)Convert.ChangeType(httpResponseMessage.Content.ReadAsByteArrayAsync().Result, typeof(T));
                else
                    retMessage.Data = (T)Convert.ChangeType(httpResponseMessage.Content.ReadAsStreamAsync(), typeof(T));
                return retMessage;
            }
        }
    }
}
