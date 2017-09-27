define(["dojo/_base/declare"], function(declare){

  var XslTransform = declare("XslTransform", [], {
    _xslDoc : null,
    _xslPath : null,

    constructor : function(xslPath) {
      this._xslPath = xslPath;
    },

    transformPath : function(xmlPath) {
      if (this._xslDoc === null)
        this._xslDoc = this._loadXML(this._xslPath);

      var result = null;
      var xmlDoc = this._loadXML(xmlPath);

      if (dojo.isIE) {
        result = xmlDoc.transformNode(this._xslDoc);
      } else if(typeof XSLTProcessor !== undefined) {
        xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(this._xslDoc);

        var ownerDocument = document.implementation.createDocument("", "", null);
        result = xsltProcessor.transformToFragment(xmlDoc, ownerDocument);
      } else {
        alert("Your browser doesn't support XSLT!");
      }

      return result;

    },

    transformXMLDocument : function(xmlDoc) {
      if (this._xslDoc === null)
        this._xslDoc = this._loadXML(this._xslPath);

      var result = null;
      var xmlDoc1 = this.createXMLDocument(xmlDoc);

      if (dojo.isIE) {
        result = xmlDoc1.transformNode(this._xslDoc);
      } else if(typeof XSLTProcessor !== undefined) {
        xsltProcessor = new XSLTProcessor();
        xsltProcessor.importStylesheet(this._xslDoc);

        var ownerDocument = document.implementation.createDocument("", "", null);
        result = xsltProcessor.transformToFragment(xmlDoc1, ownerDocument);
      } else {
        alert("Your browser doesn't support XSLT!");
      }

      return result;

    },

    createXMLDocument : function(xmlText) {
      var xmlDoc = null;

      if (dojo.isIE) {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = false;
        xmlDoc.loadXML(xmlText);
      } else if (window.DOMParser) {
        parser = new DOMParser();
        xmlDoc = parser.parseFromString(xmlText, "text/xml");
      } else {
        alert("Your browser doesn't suppoprt XML parsing!");
      }

      return xmlDoc;
    },

    // Synchronously loads a remote xml file
    _loadXML : function(xmlPath) {
      var getResult = dojo.xhrGet({
        url : xmlPath,
        handleAs : "xml",
        sync: true
      });

      var xml = null;
      // Returns immediately, because the GET is synchronous.
      var xmlData = getResult.then(function (response) {
        xml = response;
      });

      return xml;
    }
  });

  return XslTransform;

});
