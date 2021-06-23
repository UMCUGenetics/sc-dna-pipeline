;; Copyright (C) 2021  Roel Janssen <roel@gnu.org>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(use-modules (guix packages)
             ((guix licenses) #:prefix license:)
             (gnu packages autotools)
             (gnu packages bioconductor)
             (gnu packages cran)
             (gnu packages statistics)
             (gnu packages)
             (guix build utils)
             (guix build-system gnu)
             (guix build-system r)
             (guix download)
             (guix git-download)
             (guix packages))

;; This version of AneuFinder allows one to disable the plotting, which
;; speeds up the pipeline, because it runs AneuFinder multiple times.
(define r-aneufinder-umcu
  (package
    (name "r-aneufinder")
    (version "1.15.2-umcu")
    (source (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/UMCUGenetics/aneufinder.git")
                   (commit "c6cc4150f26da2966e22233168530cd4afac37ca")))
             (sha256
              (base32
               "12ygw3y9z01l9d2qlp5dq3pba58hs6w2qiv8r81riq72mzvsvp7r"))))
    (build-system r-build-system)
    (native-inputs
     `(("r-knitr" ,r-knitr)))
    (propagated-inputs
     `(("r-genomicranges" ,r-genomicranges)
       ("r-aneufinderdata" ,r-aneufinderdata)
       ("r-ecp" ,r-ecp)
       ("r-foreach" ,r-foreach)
       ("r-doparallel" ,r-doparallel)
       ("r-biocgenerics" ,r-biocgenerics)
       ("r-s4vectors" ,r-s4vectors)
       ("r-genomeinfodb" ,r-genomeinfodb)
       ("r-iranges" ,r-iranges)
       ("r-rsamtools" ,r-rsamtools)
       ("r-bamsignals" ,r-bamsignals)
       ("r-dnacopy" ,r-dnacopy)
       ("r-biostrings" ,r-biostrings)
       ("r-genomicalignments" ,r-genomicalignments)
       ("r-ggplot2" ,r-ggplot2)
       ("r-reshape2" ,r-reshape2)
       ("r-ggdendro" ,r-ggdendro)
       ("r-ggrepel" ,r-ggrepel)
       ("r-reordercluster" ,r-reordercluster)
       ("r-mclust" ,r-mclust)
       ("r-cowplot" ,r-cowplot)))
    (home-page "https://bioconductor.org/packages/AneuFinder/")
    (synopsis "Copy number variation analysis in single-cell-sequencing data")
    (description "This package contains a modified version of Aneufinder that
includes the GCSC correction method.  When in doubt, use the unmodified version
instead.")
    (license license:artistic2.0)))

(define r-uscdtools
  (package
   (name "r-uscdtools")
   (version "0.1.0")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/UMCUGenetics/USCDtools.git")
                  (commit "2105e326b53d2163bf6a3ef29d789387b964107a")))
            (sha256
             (base32
              "1bqp997asd86nd1jaqkqhnapgd4wj9hh4h8h6mdl6p8dm5z8sj27"))))
   (build-system r-build-system)
   (native-inputs
    `(("r-knitr" ,r-knitr)))
   (propagated-inputs
    `(("r-genomicranges" ,r-genomicranges)
      ("r-genomeinfodb" ,r-genomeinfodb)
      ("r-iranges" ,r-iranges)
      ("r-ggplot2" ,r-ggplot2)
      ("r-aneufinder" ,r-aneufinder-umcu)
      ("r-rsamtools" ,r-rsamtools)
      ("r-rhtslib" ,r-rhtslib)
      ("r-venndiagram" ,r-venndiagram)
      ("r-scales" ,r-scales)
      ("r-s4vectors" ,r-s4vectors)))
   (home-page "https://github.com/UMCUGenetics/USCDtools/")
   (synopsis "Utilities for the Single-Cell DNA Sequencing pipeline")
   (description "This package contains helper functions for the
sc-dna-pipeline.")
   (license license:gpl3+)))

(define sc-dna-pipeline
  (package
   (name "sc-dna-pipeline")
   (version "1.0")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/UMCUGenetics/sc-dna-pipeline.git")
                  (commit "3eb6eeab4dd813f195237c8a14bf6b35a074d12e")))
            (sha256
             (base32 "1g87n7y6zwb8813krjmldawnn4qb4yjs2xfk9ldpak5y5lsp00j1"))))
   (build-system gnu-build-system)
   (arguments
    `(#:tests? #f ; There are no tests.
      #:phases
      (modify-phases %standard-phases
        (delete 'build) ; The code is a single R script.
        (replace 'install
          (lambda* (#:key inputs outputs #:allow-other-keys)
            (let* ((out (assoc-ref outputs "out"))
                   (bin (string-append out "/bin")))
              (mkdir-p bin)
              (install-file "sc-dna-pipeline" bin)))))))
   (native-inputs
    `(("autoconf" ,autoconf)
      ("automake" ,automake)
      ("libtool" ,libtool)))
   (propagated-inputs
    `(("r" ,r-minimal)
      ("r-getopt" ,r-getopt)
      ("r-uscdtools" ,r-uscdtools)
      ("r-aneufinder" ,r-aneufinder-umcu)))
   (home-page "https://github.com/UMCUGenetics/sc-dna-pipeline/")
   (synopsis #f)
   (description #f)
   (license license:gpl3+)))

sc-dna-pipeline
