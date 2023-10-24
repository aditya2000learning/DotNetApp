FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source
COPY *.sln .
COPY **/*.csproj ./DotNetApp.Web/
RUN dotnet restore

COPY . .
WORKDIR /source/DotNetApp.Web
RUN dotnet build -c release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish -c release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=publish /app/publish ./
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet"]
CMD ["DotNetApp.Web.dll"]
