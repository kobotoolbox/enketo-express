/* global describe, require, it, beforeEach */
'use strict';

// safer to ensure this here (in addition to grunt:env:test)
process.env.NODE_ENV = 'test';

var model = require( '../../app/models/manifest-model' );
var chai = require( 'chai' );
var expect = chai.expect;

describe( 'Manifest Model', function() {

    describe( 'creating a manifest', function() {
        var result;
        var dataUri = 'data:image/svg+xml;base64,PD94bW==';
        var localLink = '#LOCAL';
        var html = '<html>' +
            '<head><link href="/css/theme-kobo.css"/></head>' +
            '<body><script src="/js/src/module/gui.js"></script><img src="' + dataUri + '" /><img src="' + localLink + '" /></body>' +
            '</html>';

        beforeEach( function( done ) {
            model.get( html )
                .then( function( manifest ) {
                    result = manifest;

                } )
                .then( done, done );
        } );

        it( 'includes the relevant manifest sections', function() {
            expect( result ).to.contain( 'CACHE MANIFEST' );
            expect( result ).to.contain( 'CACHE:' );
            expect( result ).to.contain( 'FALLBACK:\n/_ /offline' );
            expect( result ).to.contain( 'NETWORK:\n*' );
        } );

        it( 'includes the expected resources', function() {
            expect( result ).to.contain( '/css/theme-kobo.css' );
            expect( result ).to.contain( '/css/theme-formhub.css' );
            expect( result ).to.contain( '/css/theme-grid.css' );
            expect( result ).to.contain( '/css/theme-theme.css' );
            expect( result ).to.contain( '/fonts/fontawesome-webfont.woff' );
            expect( result ).to.contain( '/fonts/fontawesome-webfont.svg' );
            expect( result ).to.contain( '/fonts/OpenSans-Regular-webfont.woff' );
            expect( result ).to.contain( '/fonts/OpenSans-Regular-webfont.ttf' );
            expect( result ).to.contain( '/fonts/OpenSans-Regular-webfont.svg' );
            expect( result ).to.contain( '/fonts/OpenSans-Bold-webfont.woff' );
            expect( result ).to.contain( '/fonts/OpenSans-Bold-webfont.svg' );
            expect( result ).to.contain( '/fonts/enketo-icons-v2.woff' );
            expect( result ).to.contain( '/fonts/enketo-icons-v2.ttf' );
            expect( result ).to.contain( '/fonts/enketo-icons-v2.svg' );
            expect( result ).to.contain( '/material-design-icons/Material-Design-Icons.svg' );
            expect( result ).to.contain( '/material-design-icons/Material-Design-Icons.ttf' );
            expect( result ).to.contain( '/material-design-icons/Material-Design-Icons.eot' );
            expect( result ).to.contain( '/material-design-icons/Material-Design-Icons.woff' );
            expect( result ).to.contain( '/material-design-icons/Material-Design-Icons.woff2' );
            expect( result ).to.contain( '/roboto/Roboto-Bold.ttf' );
            expect( result ).to.contain( '/roboto/Roboto-Light.ttf' );
            expect( result ).to.contain( '/roboto/Roboto-Medium.ttf' );
            expect( result ).to.contain( '/roboto/Roboto-Regular.ttf' );
            expect( result ).to.contain( '/roboto/Roboto-Thin.ttf' );
            expect( result ).to.contain( '/roboto/Roboto-Bold.woff' );
            expect( result ).to.contain( '/roboto/Roboto-Light.woff' );
            expect( result ).to.contain( '/roboto/Roboto-Medium.woff' );
            expect( result ).to.contain( '/roboto/Roboto-Regular.woff' );
            expect( result ).to.contain( '/roboto/Roboto-Thin.woff' );
            expect( result ).to.contain( '/roboto/Roboto-Bold.woff2' );
            expect( result ).to.contain( '/roboto/Roboto-Light.woff2' );
            expect( result ).to.contain( '/roboto/Roboto-Medium.woff2' );
            expect( result ).to.contain( '/roboto/Roboto-Regular.woff2' );
            expect( result ).to.contain( '/roboto/Roboto-Thin.woff2' );
            expect( result ).to.contain( '/js/src/module/gui.js' );
        } );

        it( 'excludes dataUri sources', function() {
            expect( result ).not.to.contain( dataUri );
        } );

        it( 'excludes local resources', function() {
            expect( result ).not.to.contain( localLink );
        } );

    } );
} );
