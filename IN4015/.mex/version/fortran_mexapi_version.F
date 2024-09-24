#include <fintrf.h>
      subroutine mexfilerequiredapiversion(built_by_rel, target_api_ver)
         integer*4 built_by_rel(1), target_api_ver(1)
         built_by_rel(1) = int(z'2024a')
         target_api_ver(1) = int(FORT_MX_TARGET_API_VER)
      end

