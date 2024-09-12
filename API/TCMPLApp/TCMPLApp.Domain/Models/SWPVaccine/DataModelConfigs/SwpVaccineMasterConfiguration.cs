using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    public class SwpVaccineMasterConfiguration : IEntityTypeConfiguration<SwpVaccineMaster>
    {
        public void Configure(EntityTypeBuilder<SwpVaccineMaster> entity)
        {
            entity.HasKey(e => e.VaccineType)
                .HasName("SWP_VACCINE_MASTER_PK");

            entity.Property(e => e.VaccineType).IsUnicode(false);

            entity.Property(e => e.CompanyProviding).IsUnicode(false);
        }
    }
}
