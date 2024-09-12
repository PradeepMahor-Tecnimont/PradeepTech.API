namespace TCMPLApp.WebApi.Repositories
{
    public interface IHtmlToOpenXmlDoc
    {
        public Task<byte[]> GenerateOpenXmlDoc(string HtmlContent);
    }
}
