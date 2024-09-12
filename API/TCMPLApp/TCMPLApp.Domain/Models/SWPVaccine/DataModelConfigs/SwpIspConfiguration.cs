using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpIspConfiguration : IEntityTypeConfiguration<SwpIsp>
    {
        public void Configure(EntityTypeBuilder<SwpIsp> entity)
        {
            entity.HasKey(e => e.IspName)
                .HasName("SWP_ISP_PK");

            entity.Property(e => e.IspName).IsUnicode(false);

            entity.Property(e => e.IsEligible).IsUnicode(false);
        }
    }

}
