using Microsoft.Extensions.Localization;
using System.Reflection;

namespace TCMPLApp.WebApp.Services
{
    public class SharedViewLocalizer

    {
        private readonly IStringLocalizer _localizer;

        public SharedViewLocalizer(IStringLocalizerFactory factory)
        {
            var assemblyName = new AssemblyName(typeof(SharedResource).GetTypeInfo().Assembly.FullName);

            _localizer = factory.Create("SharedResource", assemblyName.Name);
        }

        public LocalizedString this[string key] => _localizer[key];

        public LocalizedString GetLocalizedString(string key)
        {
            return _localizer[key];
        }
    }
}

