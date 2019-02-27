FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["dokerunittestspike/dokerunittestspike.csproj", "dokerunittestspike/"]
RUN dotnet restore "dokerunittestspike/dokerunittestspike.csproj"
COPY . .
WORKDIR "/src/dokerunittestspike"
RUN dotnet build "dokerunittestspike.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "dokerunittestspike.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "dokerunittestspike.dll"]