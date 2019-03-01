FROM microsoft/dotnet:2.2-aspnetcore-runtime-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk-alpine AS build
WORKDIR /src

COPY ["dockerunittestspike.dto/dockerunittestspike.dto.csproj", "dockerunittestspike.dto/"]
COPY ["dockerunittestspike.domain/dockerunittestspike.domain.csproj", "dockerunittestspike.domain/"]
COPY ["dockerunittestspike.dataaccess/dockerunittestspike.dataaccess.csproj", "dockerunittestspike.dataaccess/"]
COPY ["dockerunittestspike.services/dockerunittestspike.services.csproj", "dockerunittestspike.services/"]
COPY ["dockerunittestspike.unit.tests/dockerunittestspike.unit.tests.csproj", "dockerunittestspike.unit.tests/"]
COPY ["dokerunittestspike/dokerunittestspike.csproj", "dokerunittestspike/"]
RUN dotnet restore /src/dokerunittestspike/dokerunittestspike.csproj
COPY . .
WORKDIR /src/dokerunittestspike
RUN dotnet build "dokerunittestspike.csproj" -c Release -o /app

FROM build as testrunner
WORKDIR /src/dockerunittestspike.unit.tests
RUN dotnet tool install dotnet-reportgenerator-globaltool --tool-path /dotnetglobaltools
LABEL unittestlayer=true
RUN dotnet test --logger "trx;LogFileName=dockerunittestspiketestresults.xml" /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura /p:CoverletOutput=/out/testresults/coverage/ /p:Exclude="[xunit.*]*" --results-directory /out/testresults
RUN /dotnetglobaltools/reportgenerator "-reports:/out/testresults/coverage/coverage.cobertura.xml" "-targetdir:/out/testresults/coverage/reports" "-reporttypes:HTMLInline;HTMLChart"
 
FROM build AS publish
RUN dotnet publish "dokerunittestspike.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "dokerunittestspike.dll"]