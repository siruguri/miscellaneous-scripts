For a more historical approach, see in particular the articles Astronomia nova and Epitome Astronomiae Copernicanae.

In astronomy, Kepler's laws of planetary motion are three scientific laws describing the motion of planets around the Sun.
Figure 1: Illustration of Kepler's three laws with two planetary orbits.
(1) The orbits are ellipses, with focal points ƒ1 and ƒ2 for the first planet and ƒ1 and ƒ3 for the second planet. The Sun is placed in focal point ƒ1.

(2) The two shaded sectors A1 and A2 have the same surface area and the time for planet 1 to cover segment A1 is equal to the time to cover segment A2.

(3) The total orbit times for planet 1 and planet 2 have a ratio a13/2 : a23/2.
Astrodynamics
Angular parameters of an elliptical orbit
Orbital mechanics
Equations
[hide]

    Kepler's laws
        Tsiolkovsky rocket equation
	    Vis-viva equation

Efficiency measures
[show]

    v t e

    The orbit of a planet is an ellipse with the Sun at one of the two foci.
        A line segment joining a planet and the Sun sweeps out equal areas during equal intervals of time.[1]
	    The square of the orbital period of a planet is proportional to the cube of the semi-major axis of its orbit.

Most planetary orbits are almost circles, and careful observation and calculation is required in order to establish that they are actually ellipses. Calculations of the orbit of the planet Mars first indicated to Johannes Kepler its elliptical shape, and he inferred that other heavenly bodies, including those farther away from the Sun, also have elliptical orbits.

Kepler's work (published between 1609-1619) improved the heliocentric theory of Nicolaus Copernicus, explaining how the planets' speeds varied, and using elliptical orbits rather than circular orbits with epicycles.[2]

Isaac Newton showed in 1687 that relationships like Kepler's would apply in the solar system to a good approximation, as consequences of his own laws of motion and law of universal gravitation.

Kepler's laws are part of the foundation of modern astronomy and physics.[3]

Contents

    1 Comparison to Copernicus
        2 Nomenclature
	    3 History
	        4 Formulary
		        4.1 First law
			        4.2 Second law
				        4.3 Third law
					    5 Planetary acceleration
					            5.1 Acceleration vector
						            5.2 The inverse square law
							            5.3 Newton's law of gravitation
								        6 Position as a function of time
									        6.1 Mean anomaly, M
										        6.2 Eccentric anomaly, E
											        6.3 True anomaly, θ
												        6.4 Distance, r
													    7 See also
													        8 Notes
														    9 References
														        10 Bibliography
															    11 External links

Comparison to Copernicus

Kepler's laws improve the model of Copernicus. If the eccentricities of the planetary orbits are taken as zero, then Kepler basically agrees with Copernicus:

    The planetary orbit is a circle
        The Sun at the center of the orbit
	    The speed of the planet in the orbit is constant

The eccentricities of the orbits of those planets known to Copernicus and Kepler are small, so the foregoing rules give good approximations of planetary motion; but Kepler's laws fit the observations better than Copernicus's.

Kepler's corrections are not at all obvious:

    The planetary orbit is not a circle, but an ellipse.
        The Sun is not at the center but at a focal point of the elliptical orbit.
	    Neither the linear speed nor the angular speed of the planet in the orbit is constant, but the area speed is constant.

The eccentricity of the orbit of the Earth makes the time from the March equinox to the September equinox, around 186 days, unequal to the time from the September equinox to the March equinox, around 179 days. A diameter would cut the orbit into equal parts, but the plane through the sun parallel to the equator of the earth cuts the orbit into two parts with areas in a 186 to 179 ratio, so the eccentricity of the orbit of the Earth is approximately

    \varepsilon\approx\frac \pi 4 \frac {186-179}{186+179}\approx 0.015,

which is close to the correct value (0.016710219) (see Earth's orbit). The calculation is correct when perihelion, the date the Earth is closest to the Sun, falls on a solstice. The current perihelion, near January 4th, is fairly close to the solstice of December 21 or 22.
Nomenclature

It took nearly two centuries for the current formulation of Kepler's work to take on its settled form. Voltaire's Eléments de la philosophie de Newton (Elements of Newton's Philosophy) of 1738 was the first publication to use the terminology of "laws".[4][5] The Biographical Encyclopedia of Astronomers in its article on Kepler (p. 620) states that the terminology of scientific laws for these discoveries was current at least from the time of Joseph de Lalande.[6] It was the exposition of Robert Small, in An account of the astronomical discoveries of Kepler (1804) that made up the set of three laws, by adding in the third.[7] Small also claimed, against the history, that these were empirical laws, based on inductive reasoning.[5][8]

Further, the current usage of "Kepler's Second Law" is something of a misnomer. Kepler had two versions of it, related in a qualitative sense, the "distance law" and the "area law". The "area law" is what became the Second Law in the set of three; but Kepler did himself not privilege it in that way.[9]
History

Johannes Kepler published his first two laws about planetary motion in 1609, having found them by analyzing the astronomical observations of Tycho Brahe.[10][2][11] Kepler's third law was published in 1619.[12][2]

Kepler in 1621 and Godefroy Wendelin in 1643 noted that Kepler's third law applies to the four brightest moons of Jupiter.[Nb 1] The second law, in the "area law" form, was contested by Nicolaus Mercator in a book from 1664; but by 1670 he was publishing in its favour in Philosophical Transactions, and as the century proceeded it became more widely accepted.[13] The reception in Germany changed noticeably between 1688, the year in which Newton's Principia was published and was taken to be basically Copernican, and 1690, by which time work of Gottfried Leibniz on Kepler had been published.[14]

Newton is credited with understanding that the second law is not special to the inverse square law of gravitation, being a consequence just of the radial nature of that law; while the other laws do depend on the inverse square form of the attraction. Carl Runge and Wilhelm Lenz much later identified a symmetry principle in the phase space of planetary motion (the orthogonal group O(4) acting) which accounts for the first and third laws in the case of Newtonian gravitation, as conservation of angular momentum does via rotational symmetry for the second law.[15]
Formulary

The mathematical model of the kinematics of a planet subject to the laws allows a large range of further calculations.
First law

    The orbit of every planet is an ellipse with the Sun at one of the two foci.

Figure 2: Kepler's first law placing the Sun at the focus of an elliptical orbit
Figure 4: Heliocentric coordinate system (r, θ) for ellipse. Also shown are: semi-major axis a, semi-minor axis b and semi-latus rectum p; center of ellipse and its two foci marked by large dots. For θ = 0°, r = rmin and for θ = 180°, r = rmax.

Mathematically, an ellipse can be represented by the formula:

    r=\frac{p}{1+\varepsilon\, \cos\theta},

where p is the semi-latus rectum, and ε is the eccentricity of the ellipse, and r is the distance from the Sun to the planet, and θ is the angle to the planet's current position from its closest approach, as seen from the Sun. So (r, θ) are polar coordinates.

For an ellipse 0 < ε < 1 ; in the limiting case ε = 0, the orbit is a circle with the sun at the centre (i.e. where there is no, or nil, eccentricity).

At θ = 0°, perihelion, the distance is minimum

    r_\min=\frac{p}{1+\varepsilon}

At θ = 90° and at θ = 270° the distance is equal to p.

At θ = 180°, aphelion, the distance is maximum (by definition, aphelion is - invariably - perihelion plus 180°)

    r_\max=\frac{p}{1-\varepsilon}

The semi-major axis a is the arithmetic mean between rmin and rmax:

    \,r_\max - a=a-r_\min

    a=\frac{p}{1-\varepsilon^2}

The semi-minor axis b is the geometric mean between rmin and rmax:

    \frac{r_\max} b =\frac b{r_\min}

    b=\frac p{\sqrt{1-\varepsilon^2}}

The semi-latus rectum p is the harmonic mean between rmin and rmax:

    \frac{1}{r_\min}-\frac{1}{p}=\frac{1}{p}-\frac{1}{r_\max}

    pa=r_\max r_\min=b^2\,

The eccentricity ε is the coefficient of variation between rmin and rmax:

    \varepsilon=\frac{r_\max-r_\min}{r_\max+r_\min}.

The area of the ellipse is

    A=\pi a b\,.

The special case of a circle is ε = 0, resulting in r = p = rmin = rmax = a = b and A = π r2.
Second law

    A line joining a planet and the Sun sweeps out equal areas during equal intervals of time.[1]

The same (blue) area is swept out in a given time. The green arrow is velocity. The purple arrow directed towards the Sun is the acceleration. The other two purple arrows are acceleration components parallel and perpendicular to the velocity.

The orbital radius and angular velocity of the planet in the elliptical orbit will vary. This is shown in the animation: the planet travels faster when closer to the sun, then slower when farther from the sun. Kepler's second law states that the blue sector has constant area.

In a small time dt\, the planet sweeps out a small triangle having base line r\, and height r \, d\theta and area dA=\tfrac 1 2\cdot r\cdot r d\theta and so the constant areal velocity is \frac{dA}{dt}=\tfrac{1}{2}r^2 \frac{d\theta}{dt}.

The area enclosed by the elliptical orbit is \pi ab.\, So the period P\, satisfies

    P\cdot \tfrac 12r^2 \frac{d\theta}{dt}=\pi a b

and the mean motion of the planet around the Sun

    n = 2\pi/P

satisfies

    r^2 \, d\theta = a b n \,dt .

Third law

    The square of the orbital period of a planet is directly proportional to the cube of the semi-major axis of its orbit.

This captures the relationship between the distance of planets from the Sun, and their orbital periods.

For a brief biography of Kepler and discussion of his third law, see: NASA: Stargaze.

Kepler enunciated in 1619 [12] this third law in a laborious attempt to determine what he viewed as the "music of the spheres" according to precise laws, and express it in terms of musical notation.[16] So it was known as the harmonic law.[17]

Mathematically, the law says that the expression

    P^2/a^3

has the same value for all the planets in the solar system. Here P is the time taken for a planet to complete an orbit round the sun, and a is the mean value between the maximum and minimum distances between the planet and sun.
Planetary acceleration
A sudden sunward velocity change is applied to a planet. Then the areas of the triangles defined by the path of the planet for fixed time intervals will be equal. (Click on image for a detailed description.)

Isaac Newton computed in his Philosophiæ Naturalis Principia Mathematica the acceleration of a planet moving according to Kepler's first and second law.

    The direction of the acceleration is towards the Sun.
        The magnitude of the acceleration is inversely proportional to the square of the planet's distance from the Sun (the inverse square law).

This implies that the Sun may be the physical cause of the acceleration of planets.

Newton defined the force acting on a planet to be the product of its mass and the acceleration (see Newton's laws of motion). So:

    Every planet is attracted towards the Sun.
        The force acting on a planet is in direct proportion to the mass of the planet and in inverse proportion to the square of its distance from the Sun.

The Sun plays an unsymmetrical part, which is unjustified. So he assumed, in Newton's law of universal gravitation:

    All bodies in the solar system attract one another.
        The force between two bodies is in direct proportion to the product of their masses and in inverse proportion to the square of the distance between them.

As the planets have small masses compared to that of the Sun, the orbits conform approximately to Kepler's laws. Newton's model improves upon Kepler's model, and fits actual observations more accurately (see two-body problem).

A deviation in the motion of a planet from Kepler's laws due to gravitational attraction by other planets is called a perturbation.

Below comes the detailed calculation of the acceleration of a planet moving according to Kepler's first and second laws.
Acceleration vector
See also: Polar coordinate § Vector calculus and Mechanics of planar particle motion

From the heliocentric point of view consider the vector to the planet \mathbf{r} = r \hat{\mathbf{r}} where r is the distance to the planet and the direction \hat {\mathbf{r}} is a unit vector. When the planet moves the directions change:

    \frac{d\hat{\mathbf{r}}}{dt}=\dot{\hat{\mathbf{r}}} = \dot\theta \hat{\boldsymbol\theta},\qquad \frac{d\hat{\boldsymbol\theta}}{dt}=\dot{\hat{\boldsymbol\theta}} = -\dot\theta \hat{\mathbf{r}}

where \hat{\boldsymbol\theta} is the unit vector orthogonal to \hat{\mathbf{r}} and pointing in the direction of rotation, and \theta is the polar angle, and where a dot on top of the variable signifies differentiation with respect to time.

So differentiating the position vector twice to obtain the velocity and the acceleration vectors:

    \dot{\mathbf{r}} =\dot{r} \hat{\mathbf{r}} + r \dot{\hat{\mathbf{r}}} =\dot{r} \hat{\mathbf{r}} + r \dot{\theta} \hat{\boldsymbol{\theta}},
        \ddot{\mathbf{r}} = (\ddot{r} \hat{\mathbf{r}} +\dot{r} \dot{\hat{\mathbf{r}}} ) + (\dot{r}\dot{\theta} \hat{\boldsymbol{\theta}} + r\ddot{\theta} \hat{\boldsymbol{\theta}} + r\dot{\theta} \dot{\hat{\boldsymbol{\theta}}}) = (\ddot{r} - r\dot{\theta}^2) \hat{\mathbf{r}} + (r\ddot{\theta} + 2\dot{r} \dot{\theta}) \hat{\boldsymbol{\theta}}.

So

    \ddot{\mathbf{r}} = a_r \hat{\boldsymbol{r}}+a_\theta\hat{\boldsymbol{\theta}}

where the radial acceleration is

    a_r=\ddot{r} - r\dot{\theta}^2

and the transversal acceleration is

    a_\theta=r\ddot{\theta} + 2\dot{r} \dot{\theta}.

The inverse square law

Kepler's laws say that

    r^2\dot \theta = nab

is constant.

The transversal acceleration a_\theta is zero:

    \frac{d (r^2 \dot \theta)}{dt} = r (2 \dot r \dot \theta + r \ddot \theta ) = r a_\theta = 0.

So the acceleration of a planet obeying Kepler's laws is directed towards the sun.

The radial acceleration a_r is

    a_r = \ddot r - r \dot \theta^2= \ddot r - r \left(\frac{nab}{r^2} \right)^2= \ddot r -\frac{n^2a^2b^2}{r^3}.

Kepler's first law states that the orbit is described by the equation:

    \frac{p}{r} = 1+ \varepsilon \cos\theta.

Differentiating with respect to time

    -\frac{p\dot r}{r^2} = -\varepsilon \sin \theta \,\dot \theta

or

    p\dot r = nab\,\varepsilon\sin \theta.

Differentiating once more

    p\ddot r =nab \varepsilon \cos \theta \,\dot \theta =nab \varepsilon \cos \theta \,\frac{nab}{r^2} =\frac{n^2a^2b^2}{r^2}\varepsilon \cos \theta .

The radial acceleration a_r satisfies

    p a_r = \frac{n^2 a^2b^2}{r^2}\varepsilon \cos \theta - p\frac{n^2 a^2b^2}{r^3} = \frac{n^2a^2b^2}{r^2}\left(\varepsilon \cos \theta - \frac{p}{r}\right).

Substituting the equation of the ellipse gives

    p a_r = \frac{n^2a^2b^2}{r^2}\left(\frac p r - 1 - \frac p r\right)= -\frac{n^2a^2}{r^2}b^2.

The relation b^2=pa gives the simple final result

    a_r=-\frac{n^2a^3}{r^2}.

This means that the acceleration vector \mathbf{\ddot r} of any planet obeying Kepler's first and second law satisfies the inverse square law

    \mathbf{\ddot r} = - \frac{\alpha}{r^2}\hat{\mathbf{r}}

where

    \alpha = n^2 a^3\,

is a constant, and \hat{\mathbf r} is the unit vector pointing from the Sun towards the planet, and r\, is the distance between the planet and the Sun.

According to Kepler's third law, \alpha has the same value for all the planets. So the inverse square law for planetary accelerations applies throughout the entire solar system.

The inverse square law is a differential equation. The solutions to this differential equation include the Keplerian motions, as shown, but they also include motions where the orbit is a hyperbola or parabola or a straight line. See Kepler orbit.
Newton's law of gravitation

By Newton's second law, the gravitational force that acts on the planet is:

    \mathbf{F} = m_\text{Planet} \mathbf{\ddot r} = - m_\text{Planet} \alpha r^{-2} \hat{\mathbf{r}}

where m_\text{Planet} is the mass of the planet and \alpha has the same value for all planets in the solar system. According to Newton's third Law, the Sun is attracted to the planet by a force of the same magnitude. Since the force is proportional to the mass of the planet, under the symmetric consideration, it should also be proportional to the mass of the Sun, m_\text{Sun}. So

    \alpha = Gm_\text{Sun}

where G is the gravitational constant.

The acceleration of solar system body number i is, according to Newton's laws:

    \mathbf{\ddot r_i} = G\sum_{j\ne i} m_j r_{ij}^{-2} \hat{\mathbf{r}}_{ij}

where m_j is the mass of body j, r_{ij} is the distance between body i and body j, \hat{\mathbf{r}}_{ij} is the unit vector from body i towards body j, and the vector summation is over all bodies in the world, besides i itself.

In the special case where there are only two bodies in the world, Earth and Sun, the acceleration becomes

    \mathbf{\ddot r}_\text{Earth} = G m_\text{Sun} r_{\text{Earth},\text{Sun}}^{-2} \hat{\mathbf{r}}_{\text{Earth},\text{Sun}}

which is the acceleration of the Kepler motion. So this Earth moves around the Sun according to Kepler's laws.

If the two bodies in the world are Moon and Earth the acceleration of the Moon becomes

    \mathbf{\ddot r}_\text{Moon} = G m_\text{Earth} r_{\text{Moon},\text{Earth}}^{-2} \hat{\mathbf{r}}_{\text{Moon},\text{Earth}}

So in this approximation the Moon moves around the Earth according to Kepler's laws.

In the three-body case the accelerations are

    \mathbf{\ddot r}_\text{Sun} = G m_\text{Earth} r_{\text{Sun},\text{Earth}}^{-2} \hat{\mathbf{r}}_{\text{Sun},\text{Earth}} + G m_\text{Moon} r_{\text{Sun},\text{Moon}}^{-2} \hat{\mathbf{r}}_{\text{Sun},\text{Moon}}
        \mathbf{\ddot r}_\text{Earth} = G m_\text{Sun} r_{\text{Earth},\text{Sun}}^{-2} \hat{\mathbf{r}}_{\text{Earth},\text{Sun}} + G m_\text{Moon} r_{\text{Earth},\text{Moon}}^{-2} \hat{\mathbf{r}}_{\text{Earth},\text{Moon}}
	    \mathbf{\ddot r}_\text{Moon} = G m_\text{Sun} r_{\text{Moon},\text{Sun}}^{-2} \hat{\mathbf{r}}_{\text{Moon},\text{Sun}}+ G m_\text{Earth} r_{\text{Moon},\text{Earth}}^{-2} \hat{\mathbf{r}}_{\text{Moon},\text{Earth}}

These accelerations are not those of Kepler orbits, and the three-body problem is complicated. But Keplerian approximation is the basis for perturbation calculations. See Lunar theory.
Position as a function of time

Kepler used his two first laws to compute the position of a planet as a function of time. His method involves the solution of a transcendental equation called Kepler's equation.

The procedure for calculating the heliocentric polar coordinates (r,θ) of a planet as a function of the time t since perihelion, is the following four steps:

    1. Compute the mean anomaly M = nt where n is the mean motion.

        n\cdot P=2\pi radians where P is the period.

    2. Compute the eccentric anomaly E by solving Kepler's equation:

        \ M=E-\varepsilon \sin E

    3. Compute the true anomaly θ by the equation:

        (1-\varepsilon) \tan^2\frac \theta 2 = (1+\varepsilon) \tan^2\frac E 2

    4. Compute the heliocentric distance

        r=a(1-\varepsilon \cos E).

The important special case of circular orbit, ε = 0, gives θ = E = M. Because the uniform circular motion was considered to be normal, a deviation from this motion was considered an anomaly.

The proof of this procedure is shown below.
Mean anomaly, M
FIgure 5: Geometric construction for Kepler's calculation of θ. The Sun (located at the focus) is labeled S and the planet P. The auxiliary circle is an aid to calculation. Line xd is perpendicular to the base and through the planet P. The shaded sectors are arranged to have equal areas by positioning of point y.

The Keplerian problem assumes an elliptical orbit and the four points:

    s the Sun (at one focus of ellipse);
        z the perihelion
	    c the center of the ellipse
	        p the planet

and

    \ a=|cz|, distance between center and perihelion, the semimajor axis,
        \ \varepsilon={|cs|\over a}, the eccentricity,
	    \ b=a\sqrt{1-\varepsilon^2}, the semiminor axis,
	        \ r=|sp| , the distance between Sun and planet.
		    \theta=\angle zsp, the direction to the planet as seen from the Sun, the true anomaly.

The problem is to compute the polar coordinates (r,θ) of the planet from the time since perihelion, t.

It is solved in steps. Kepler considered the circle with the major axis as a diameter, and

    \ x, the projection of the planet to the auxiliary circle
        \ y, the point on the circle such that the sector areas |zcy| and |zsx| are equal,
	    M=\angle zcy, the mean anomaly.

The sector areas are related by |zsp|=\frac b a \cdot|zsx|.

The circular sector area \ |zcy| = \frac{a^2 M}2.

The area swept since perihelion,

    |zsp|=\frac b a \cdot|zsx|=\frac b a \cdot|zcy|=\frac b a\cdot\frac{a^2 M}2 = \frac {a b M}{2},

is by Kepler's second law proportional to time since perihelion. So the mean anomaly, M, is proportional to time since perihelion, t.

    M=n t, \,

where n is the mean motion.
Eccentric anomaly, E

When the mean anomaly M is computed, the goal is to compute the true anomaly θ. The function θ = f(M) is, however, not elementary.[18] Kepler's solution is to use

    E=\angle zcx, x as seen from the centre, the eccentric anomaly

as an intermediate variable, and first compute E as a function of M by solving Kepler's equation below, and then compute the true anomaly θ from the eccentric anomaly E. Here are the details.

    \ |zcy|=|zsx|=|zcx|-|scx|

    \frac{a^2 M}2=\frac{a^2 E}2-\frac {a\varepsilon\cdot a\sin E}2

Division by a2/2 gives Kepler's equation

    M=E-\varepsilon\cdot\sin E.

This equation gives M as a function of E. Determining E for a given M is the inverse problem. Iterative numerical algorithms are commonly used.

Having computed the eccentric anomaly E, the next step is to calculate the true anomaly θ.
True anomaly, θ

Note from the figure that

    \overrightarrow{cd}=\overrightarrow{cs}+\overrightarrow{sd}

so that

    a\cdot\cos E=a\cdot\varepsilon+r\cdot\cos \theta.

Dividing by a and inserting from Kepler's first law

    \ \frac r a =\frac{1-\varepsilon^2}{1+\varepsilon\cdot\cos \theta}

to get

    \cos E =\varepsilon+\frac{1-\varepsilon^2}{1+\varepsilon\cdot\cos \theta}\cdot\cos \theta  =\frac{\varepsilon\cdot(1+\varepsilon\cdot\cos \theta)+(1-\varepsilon^2)\cdot\cos \theta}{1+\varepsilon\cdot\cos \theta}  =\frac{\varepsilon +\cos \theta}{1+\varepsilon\cdot\cos \theta}.

The result is a usable relationship between the eccentric anomaly E and the true anomaly θ.

A computationally more convenient form follows by substituting into the trigonometric identity:

    \tan^2\frac{x}{2}=\frac{1-\cos x}{1+\cos x}.

Get

    \tan^2\frac{E}{2} =\frac{1-\cos E}{1+\cos E}  =\frac{1-\frac{\varepsilon+\cos \theta}{1+\varepsilon\cdot\cos \theta}}{1+\frac{\varepsilon+\cos \theta}{1+\varepsilon\cdot\cos \theta}}  =\frac{(1+\varepsilon\cdot\cos \theta)-(\varepsilon+\cos \theta)}{(1+\varepsilon\cdot\cos \theta)+(\varepsilon+\cos \theta)}  =\frac{1-\varepsilon}{1+\varepsilon}\cdot\frac{1-\cos \theta}{1+\cos \theta}=\frac{1-\varepsilon}{1+\varepsilon}\cdot\tan^2\frac{\theta}{2}.

Multiplying by 1+ε gives the result

    (1-\varepsilon)\cdot\tan^2\frac \theta 2 = (1+\varepsilon)\cdot\tan^2\frac E 2

This is the third step in the connection between time and position in the orbit.
Distance, r

The fourth step is to compute the heliocentric distance r from the true anomaly θ by Kepler's first law:

    \ r\cdot(1+\varepsilon\cdot\cos \theta)=a\cdot(1-\varepsilon^2)

Using the relation above between θ and E the final equation for the distance r is:

    \ r=a\cdot(1-\varepsilon\cdot\cos E).

See also

    Circular motion
        Free-fall time
	    Gravity
	        Kepler orbit
		    Kepler problem
		        Kepler's equation
			    Laplace–Runge–Lenz vector

Notes

    Godefroy Wendelin wrote a letter to Giovanni Battista Riccioli about the relationship between the distances of the Jovian moons from Jupiter and the periods of their orbits, showing that the periods and distances conformed to Kepler's third law. See: Joanne Baptista Riccioli, Almagestum novum … (Bologna (Bononia), (Italy): Victor Benati, 1651), volume 1, page 492 Scholia III. In the margin beside the relevant paragraph is printed: Vendelini ingeniosa speculatio circa motus & intervalla satellitum Jovis. (Wendelin's clever speculation about the movement and distances of Jupiter's satellites.)
        In 1621, Johannes Kepler had noted that Jupiter's moons obey (approximately) his third law in his Epitome Astronomiae Copernicanae [Epitome of Copernican Astronomy] (Linz (“Lentiis ad Danubium“), (Austria): Johann Planck, 1622), book 4, part 2, page 554.

References

Bryant, Jeff; Pavlyk, Oleksandr. "Kepler's Second Law", Wolfram Demonstrations Project. Retrieved December 27, 2009.
Holton, Gerald James; Brush, Stephen G. (2001). Physics, the Human Adventure: From Copernicus to Einstein and Beyond (3rd paperback ed.). Piscataway, NJ: Rutgers University Press. pp. 40–41. ISBN 0-8135-2908-5. Retrieved December 27, 2009.
See also G. E. Smith, "Newton's Philosophiae Naturalis Principia Mathematica", especially the section Historical context ... in The Stanford Encyclopedia of Philosophy (Winter 2008 Edition), Edward N. Zalta (ed.).
Voltaire, [b]Eléments [/b] de la philosophie de Newton [Elements of Newton's Philosophy] (London, England: 1738). See, for example:

    From p. 162: "Par une des grandes loix de Kepler, toute Planete décrit des aires égales en temp égaux : par une autre loi non moins sûre, chaque Planete fait sa révolution autour du Soleil en telle sort, que si, sa moyenne distance au Soleil est 10. prenez le cube de ce nombre, ce qui sera 1000., & le tems de la révolution de cette Planete autour du Soleil sera proportionné à la racine quarrée de ce nombre 1000." (By one of the great laws of Kepler, each planet describes equal areas in equal times ; by another law no less certain, each planet makes its revolution around the sun in such a way that if its mean distance from the sun is 10, take the cube of that number, which will be 1000, and the time of the revolution of that planet around the sun will be proportional to the square root of that number 1000.)
        From p. 205: "Il est donc prouvé par la loi de Kepler & par celle de Neuton, que chaque Planete gravite vers le Soleil, ... " (It is thus proved by the law of Kepler and by that of Newton, that each planet revolves around the sun … )

Wilson, Curtis (May 1994). "Kepler's Laws, So-Called" (PDF). HAD News (Washington, DC: Historical Astronomy Division, American Astronomical Society) (31): 1–2. Retrieved December 27, 2009.
De la Lande, Astronomie, vol. 1 (Paris, France: Desaint & Saillant, 1764). See, for example:

    From page 390: " … mais suivant la fameuse loi de Kepler, qui sera expliquée dans le Livre suivant (892), le rapport des temps périodiques est toujours plus grand que celui des distances, une planete cinq fois plus éloignée du soleil, emploie à faire sa révolution douze fois plus de temps ou environ; … " ( … but according to the famous law of Kepler, which will be explained in the following book [i.e., chapter] (paragraph 892), the ratio of the periods is always greater than that of the distances [so that, for example,] a planet five times farther from the sun, requires about twelve times or so more time to make its revolution [around the sun]; … )
        From page 429: "Les Quarrés des Temps périodiques sont comme les Cubes des Distances. 892. La plus fameuse loi du mouvement des planetes découverte par Kepler, est celle du repport qu'il y a entre les grandeurs de leurs orbites, & le temps qu'elles emploient à les parcourir; … " (The squares of the periods are as the cubes of the distances. 892. The most famous law of the movement of the planets discovered by Kepler is that of the relation that exists between the sizes of their orbits and the times that the [planets] require to traverse them; … )
	    From page 430: "Les Aires sont proportionnelles au Temps. 895. Cette loi générale du mouvement des planetes devenue si importante dans l'Astronomie, sçavior, que les aires sont proportionnelles au temps, est encore une des découvertes de Kepler; … " (Areas are proportional to times. 895. This general law of the movement of the planets [which has] become so important in astronomy to know, [namely] that areas are proportional to times, is one of Kepler's discoveries; … )
	        From page 435: "On a appellé cette loi des aires proportionnelles aux temps, Loi de Kepler, aussi bien que celle de l'article 892, du nome de ce célebre Inventeur; … " (One called this law of areas proportional to times (the law of Kepler) as well as that of paragraph 892, by the name of that celebrated inventor; … )

Robert Small, An account of the astronomical discoveries of Kepler (London, England: J Mawman, 1804), pp. 298–299.
Robert Small, An account of the astronomical discoveries of Kepler (London, England: J. Mawman, 1804).
Bruce Stephenson (1994). Kepler's Physical Astronomy. Princeton University Press. p. 170. ISBN 0-691-03652-7.
In his Astronomia nova, Kepler presented only a proof that Mars' orbit is elliptical. Evidence that the other known planets' orbits are elliptical was presented only in 1621.
See: Johannes Kepler, Astronomia nova … (1609), p. 285. After having rejected circular and oval orbits, Kepler concluded that Mars' orbit must be elliptical. From the top of page 285: "Ergo ellipsis est Planetæ iter; … " (Thus, an ellipse is the planet's [i.e., Mars'] path; … ) Later on the same page: " … ut sequenti capite patescet: ubi simul etiam demonstrabitur, nullam Planetæ relinqui figuram Orbitæ, præterquam perfecte ellipticam; … " ( … as will be revealed in the next chapter: where it will also then be proved that any figure of the planet's orbit must be relinquished, except a perfect ellipse; … ) And then: "Caput LIX. Demonstratio, quod orbita Martis, … , fiat perfecta ellipsis: … " (Chapter 59. Proof that Mars' orbit, … , is a perfect ellipse: … ) The geometric proof that Mars' orbit is an ellipse appears as Protheorema XI on pages 289–290.
Kepler stated that all planets travel in elliptical orbits having the Sun at one focus in: Johannes Kepler, Epitome Astronomiae Copernicanae [Summary of Copernican Astronomy] (Linz ("Lentiis ad Danubium"), (Austria): Johann Planck, 1622), book 5, part 1, III. De Figura Orbitæ (III. On the figure [i.e., shape] of orbits), pages 658-665. From p. 658: "Ellipsin fieri orbitam planetæ … " (Of an ellipse is made a planet's orbit … ). From p. 659: " … Sole (Foco altero huius ellipsis) … " ( … the Sun (the other focus of this ellipse) … ).
In his Astronomia nova ... (1609), Kepler did not present his second law in its modern form. He did that only in his Epitome of 1621. Furthermore, in 1609, he presented his second law in two different forms, which scholars call the "distance law" and the "area law".

    His "distance law" is presented in: "Caput XXXII. Virtutem quam Planetam movet in circulum attenuari cum discessu a fonte." (Chapter 32. The force that moves a planet circularly weakens with distance from the source.) See: Johannes Kepler, Astronomia nova … (1609), pp. 165–167. On page 167, Kepler states: " … , quanto longior est αδ quam αε, tanto diutius moratur Planeta in certo aliquo arcui excentrici apud δ, quam in æquali arcu excentrici apud ε." ( … , as αδ is longer than αε, so much longer will a planet remain on a certain arc of the eccentric near δ than on an equal arc of the eccentric near ε.) That is, the farther a planet is from the Sun (at the point α), the slower it moves along its orbit, so a radius from the Sun to a planet passes through equal areas in equal times. However, as Kepler presented it, his argument is accurate only for circles, not ellipses.
        His "area law" is presented in: "Caput LIX. Demonstratio, quod orbita Martis, … , fiat perfecta ellipsis: … " (Chapter 59. Proof that Mars' orbit, … , is a perfect ellipse: … ), Protheorema XIV and XV, pp. 291–295. On the top p. 294, it reads: "Arcum ellipseos, cujus moras metitur area AKN, debere terminari in LK, ut sit AM." (The arc of the ellipse, of which the duration is delimited [i.e., measured] by the area AKM, should be terminated in LK, so that it [i.e., the arc] is AM.) In other words, the time that Mars requires to move along an arc AM of its elliptical orbit is measured by the area of the segment AMN of the ellipse (where N is the position of the Sun), which in turn is proportional to the section AKN of the circle that encircles the ellipse and that is tangent to it. Therefore, the area that is swept out by a radius from the Sun to Mars as Mars moves along an arc of its elliptical orbit is proportional to the time that Mars requires to move along that arc. Thus, a radius from the Sun to Mars sweeps out equal areas in equal times.

In 1621, Kepler restated his second law for any planet: Johannes Kepler, Epitome Astronomiae Copernicanae [Summary of Copernican Astronomy] (Linz ("Lentiis ad Danubium"), (Austria): Johann Planck, 1622), book 5, page 668. From page 668: "Dictum quidem est in superioribus, divisa orbita in particulas minutissimas æquales: accrescete iis moras planetæ per eas, in proportione intervallorum inter eas & Solem." (It has been said above that, if the orbit of the planet is divided into the smallest equal parts, the times of the planet in them increase in the ratio of the distances between them and the sun.) That is, a planet's speed along its orbit is inversely proportional to its distance from the Sun. (The remainder of the paragraph makes clear that Kepler was referring to what is now called angular velocity.)
Johannes Kepler, Harmonices Mundi [The Harmony of the World] (Linz, (Austria): Johann Planck, 1619), book 5, chapter 3, p. 189. From the bottom of p. 189: "Sed res est certissima exactissimaque quod proportio qua est inter binorum quorumcunque Planetarum tempora periodica, sit præcise sesquialtera proportionis mediarum distantiarum, … " (But it is absolutely certain and exact that the proportion between the periodic times of any two planets is precisely the sesquialternate proportion [i.e., the ratio of 3:2] of their mean distances, … ")
An English translation of Kepler's Harmonices Mundi is available as: Johannes Kepler with E.J. Aiton, A.M. Duncan, and J.V. Field, trans., The Harmony of the World (Philadelphia, Pennsylvania: American Philosophical Society, 1997); see especially p. 411.
Wilbur Applebaum (13 June 2000). Encyclopedia of the Scientific Revolution: From Copernicus to Newton. Routledge. p. 603. ISBN 978-1-135-58255-5.
Roy Porter (25 September 1992). The Scientific Revolution in National Context. Cambridge University Press. p. 102. ISBN 978-0-521-39699-8.
Victor Guillemin; Shlomo Sternberg (2006). Variations on a Theme by Kepler. American Mathematical Soc. p. 5. ISBN 978-0-8218-4184-6.
Burtt, Edwin. The Metaphysical Foundations of Modern Physical Science. p. 52.
Gerald James Holton, Stephen G. Brush (2001). Physics, the Human Adventure. Rutgers University Press. p. 45. ISBN 0-8135-2908-5.

    MÜLLER, M (1995). "EQUATION OF TIME -- PROBLEM IN ASTRONOMY". Acta Physica Polonica A. Retrieved 23 February 2013.

Bibliography

    Kepler's life is summarized on pages 523–627 and Book Five of his magnum opus, Harmonice Mundi (harmonies of the world), is reprinted on pages 635–732 of On the Shoulders of Giants: The Great Works of Physics and Astronomy (works by Copernicus, Kepler, Galileo, Newton, and Einstein). Stephen Hawking, ed. 2002 ISBN 0-7624-1348-4

    A derivation of Kepler's third law of planetary motion is a standard topic in engineering mechanics classes. See, for example, pages 161–164 of Meriam, J. L. (1971) [1966]. "Dynamics, 2nd ed". New York: John Wiley. ISBN 0-471-59601-9..

    Murray and Dermott, Solar System Dynamics, Cambridge University Press 1999, ISBN 0-521-57597-4
        V.I. Arnold, Mathematical Methods of Classical Mechanics, Chapter 2. Springer 1989, ISBN 0-387-96890-3

External links

    B.Surendranath Reddy; animation of Kepler's laws: applet
        "Derivation of Kepler's Laws" (from Newton's laws) at Physics Stack Exchange.
	    Crowell, Benjamin, Conservation Laws, http://www.lightandmatter.com/area1book2.html, an online book that gives a proof of the first law without the use of calculus. (see section 5.2, p. 112)
	        David McNamara and Gianfranco Vidali, Kepler's Second Law - Java Interactive Tutorial, http://www.phy.syr.edu/courses/java/mc_html/kepler.html, an interactive Java applet that aids in the understanding of Kepler's Second Law.
		    Audio - Cain/Gay (2010) Astronomy Cast Johannes Kepler and His Laws of Planetary Motion
		        University of Tennessee's Dept. Physics & Astronomy: Astronomy 161 page on Johannes Kepler: The Laws of Planetary Motion [1]
			    Equant compared to Kepler: interactive model [2]
			        Kepler's Third Law:interactive model [3]
				    Solar System Simulator (Interactive Applet)
				        Kepler and His Laws, educational web pages by David P. Stern
					
