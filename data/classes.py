import math

class Scene:
    def __init__(self):
        #Stored as RGB Tuple
        self.backgroundColor = (0,0,0)
        self.sceneObjects = []
        self.lightSources = []
        self.triangle_list = []
        self.fov = 0.0
        self.current_surface = None
        self.begin = False;
        self.vertices = []
    
        
    def end_vertex(self):
        self.begin = False
        tri = Triangle(self.vertices[0], self.vertices[1], self.vertices[2], self.current_surface)
        self.triangle_list.append(tri)
        #Clear Vertices for next batch
        self.vertices = []

    

    
    #will add more to this later
    def set_surface(self, dif_r, dif_g, dif_b, amb_r, amb_g, amb_b, spec_r, spec_g, spec_b, spec_power, reflect_K):
        self.current_surface = dif_r, dif_g, dif_b, amb_r, amb_g, amb_b, spec_r, spec_g, spec_b, spec_power, reflect_K
        

    
    def discriminant(self, a, b, c):
        return pow(b,2) - 4 * a * c
    
    def quadratic_eq(self, discrim, b, a):
        return (-b - math.sqrt(discrim))/ (2*a)
    
    def calculate_intersection(self, ray, count):
        hit = Hit()
        hit.set_ray(ray)
        #Stopping condition of recursion
        dx, dy, dz = ray.get_slope()
        if ray.get_ray_type() == "Reflection":
            dx,dy,dz = ray.get_reflection_dir()

        a = pow(dx,2) + pow(dy,2) + pow(dz,2)
        x_0, y_0, z_0 = ray.get_origin()
        
        #Check for sphere collisions 
        for object in self.sceneObjects:
            o_x, o_y, o_z = object.x, object.y, object.z
            b = 2 * ((x_0 * dx - o_x * dx) + (y_0 * dy - o_y * dy) + (z_0 * dz - o_z * dz))
            r = object.radius
            c = pow((x_0 - o_x),2) + pow((y_0 - o_y),2) + pow((z_0 - o_z),2) - pow(r,2)
            value = self.discriminant(a,b,c)
            if value >= 0:
                #there is a hit
                t = self.quadratic_eq(value, b, a)
                if hit.get_closest_object() == None and t > 0:
                    hit.set_t(t)
                    hit.set_closest_object(object)
                    hit.calculate_intersection_point(t)
                    
                    #If weird things happening try comparing t's instead of z
                elif t < hit.get_t() and t > 0:
                    hit.set_t(t)
                    hit.set_closest_object(object)
                    hit.calculate_intersection_point(t)


        #Check for triangle collisons
        for _triangle in self.triangle_list:
            t = _triangle.ray_intersect(ray)
            if t != None:
                if t > 0:
                    if hit.get_closest_object() == None:
                            hit.set_t(t)
                            hit.set_closest_object(_triangle)
                            hit.calculate_intersection_point(t)
                            
                            #If weird things happening try comparing t's instead of z
                    elif t < hit.get_t():
                            hit.set_t(t)
                            hit.set_closest_object(_triangle)
                            hit.calculate_intersection_point(t)
        
        #No object return
        if hit.get_closest_object()== None:
            return hit
        #Just checking for collisons return 
        if hit.get_ray().get_ray_type() == "Shadow":
            return hit
        
        #Normal ray or Refelctive ray continue
        
        #start on Color of the hit
        xi, yi, zi = hit.get_intersection_point()
  
        cx, cy, cz = hit.get_closest_object().getPosition()
        rx, ry,rz = hit.get_ray().get_slope()
        _rdiff, _gdiff,_bdiff, amb_r, amb_g, amb_b, spec_r, spec_g, spec_b, spec_power, reflec = hit.get_closest_object().surface

            
        ray_start = Vector(-rx,-ry,-rz) 
        intersect_point = Vector(xi,yi,zi)
        object_vector = Vector(cx, cy, cz) 
        ray_start = ray_start._norm()
 
        surface_norm = intersect_point._sub(object_vector)
        surface_norm = surface_norm._norm()
        

        V = ray_start._sub(intersect_point)
        V = V._norm()
    
        r_sum = 0
        g_sum = 0
        b_sum = 0

        x, y = ray.get_pixel()
        if hit.get_closest_object().object_type() == 'Triangle':
            surface_norm = surface_norm.flip()
        
        for light in self.lightSources:
            #Origin is the intersection point
            shadow_ray = Ray(xi+ 0.01, yi+ 0.01, zi+ 0.01, x,y)
            xlight, ylight, zlight = light.x, light.y, light.z
            #Add light ray as x,y,z for slope
            shadow_ray.set_xyz(xlight,ylight,zlight)
            shadow_ray.set_ray_type("Shadow")
            light_pos = Vector(xlight, ylight, zlight)
                
            light_vector = light_pos._sub(intersect_point)
            light_vector = light_vector._norm()

            vlsum = V._add(light_vector)

            H = vlsum._norm()
            rlight, glight, blight = light.r, light.g, light.b
            shadow_hit = self.calculate_intersection(shadow_ray,1)
            

                
            if shadow_hit.get_closest_object() != None:
                continue
            else:
                r_sum += _rdiff * rlight * max(0, surface_norm._dot(light_vector)) +  rlight * spec_r * math.pow(max(0, surface_norm._dot(H)), spec_power) 
                g_sum += _gdiff * glight * max(0, surface_norm._dot(light_vector)) +  glight * spec_g * math.pow(max(0, surface_norm._dot(H)), spec_power)
                b_sum += _bdiff * blight * max(0, surface_norm._dot(light_vector)) +  blight * spec_b * math.pow(max(0, surface_norm._dot(H)), spec_power)
                
                
        if reflec > 0 and count < 10:
            r_refl, g_refl, b_refl = 0,0,0
            scalar = surface_norm._dot(ray_start) * 2
            twoN = surface_norm.scalar_mult(scalar)
            dir = twoN._sub(ray_start)
            dir = dir._norm()
            x, y, z = dir.get_values()
            reflection_ray = Ray(xi, yi, zi, x,y)
            reflection_ray.set_ray_type("Reflection")
            reflection_ray.set_reflection_dir(x, y, z)
            count += 1
            reflection_hit = self.calculate_intersection(reflection_ray, count)
            if reflection_hit.get_closest_object() != None:
                r_refl, g_refl, b_refl = reflection_hit.get_colors()
                
                r_sum += r_refl * reflec
                g_sum += g_refl * reflec
                b_sum += b_refl * reflec
            else:
                back_r, back_g, back_b = self.backgroundColor
                r_sum += back_r * reflec
                g_sum += back_g * reflec
                b_sum += back_b * reflec
        
        r = amb_r + r_sum 
        g = amb_g + g_sum
        b = amb_b + b_sum 
        
        if r > 1:
            r = 1
        if g > 1:
            g = 1
        if b > 1:
            b = 1
        
        hit.set_colors(r, g, b)
        return hit

    
class MySphere:
    def __init__(self, x, y, z, radius, surface):
        self.x = x
        self.y = y
        self.z = z
        self.radius = radius
        self.surface = surface
    
    def object_type(self):
        return "Sphere"
    
    def getPosition(self):
        return self.x, self.y, self.z
        



class Triangle:
    
    def __init__(self, v0, v1, v2, surface):
        self.v0 = v0
        self.v1 = v1
        self.v2 = v2
        self.surface = surface
        A = v1._sub(v0)
        B = v2._sub(v0)
        C = A._cross(B)
        self.N = C._norm()
        self.D = self.N._dot(v0)
        
    def get_norm(self):
        return self.N
    
    def getPosition(self):
        return self.N.get_values()
        
    def object_type(self):
        return "Triangle"
        
    
    def ray_intersect(self, ray):
        xo,yo,zo = ray.get_origin()
        dx,dy,dz = ray.get_slope()
        
        if ray.get_ray_type() == "Reflection":
            dx,dy,dz = ray.get_reflection_dir()
            
        ray_origin = Vector(xo,yo,zo)
        ray_dir = Vector(dx,dy,dz)
        
        NDotDir = self.N._dot(ray_dir)
        if math.fabs(NDotDir) < 0.001:
            return None
        if NDotDir < 0: 
            self.N = self.N.flip()
            NDotDir = self.N._dot(ray_dir)
       
        t = (self.N._dot(ray_origin) + self.D)/ NDotDir
        
        if t < 0:
            return None
        
        p1 = xo + t * dx
        p2 = yo + t * dy
        p3 = zo + t * dz
        P = Vector(p1, p2, p3)
        edge0 = self.v1._sub(self.v0)
        edge1 = self.v2._sub(self.v1)
        edge2 = self.v0._sub(self.v2)
        c0 = P._sub(self.v0)
        c1 = P._sub(self.v1)
        c2 = P._sub(self.v2)
        
        if (self.N._dot(edge0._cross(c0)) > 0 and 
            self.N._dot(edge1._cross(c1)) > 0 and 
            self.N._dot(edge2._cross(c2)) > 0 ):
            return t
        else:
            return None
        
        
class Light:
    def __init__(self, x, y, z, r, g, b):
        self.x = x
        self.y = y
        self.z = z
        self.r = r
        self.g = g
        self.b = b
    
    
class Vector:
    def __init__(self, x, y, z):
        self.x = float(x)
        self.y = float(y)
        self.z = float(z)
        
        
    def _add(self,v):
        return Vector(self.x + v.getX(), self.y + v.getY(), self.z + v.getZ()) 
    
    def get_values(self):
        return self.x, self.y, self.z
    
    def flip(self):
        return Vector(self.x * -1, self.y * -1, self.z * -1)
    
    def scalar_mult(self, num):
        return Vector(num * self.x, num * self.y, num * self.z)
    
    def _norm(self):
        _mag = float(math.sqrt(self.x**2 + self.y**2 + self.z**2))
        return Vector(self.x/_mag, self.y/_mag, self.z/_mag)
    
    def _abs(self):
        return Vector(math.fabs(self.x), math.fabs(self.y), math.fabs(self.z))
    
    def _dot(self, vect):
    
        return self.x * vect.getX() + self.y * vect.getY() + self.z * vect.getZ()

    def _cross(self, vect):
        return Vector(self.y * vect.getZ() - self.z * vect.getY(),
            self.z * vect.getX() - self.x * vect.getZ(),
            self.x * vect.getY() - self.y * vect.getX())

    def _sub(self, vect):
        return Vector(self.x - vect.getX(), self.y - vect.getY(), self.z - vect.getZ())
    
    def getX(self):
        return self.x
    
    def getY(self):
        return self.y
    
    def getZ(self):
        return self.z
    
class Hit:
    
    def __init__(self):
        self.closest_object = None
        self.intersection_point = None
        self.ray = None
        self.t = None
        #Pixels, Debug
        self.x = None
        self.y = None
        self.f_color = None
        
    def set_closest_object(self, object):
        self.closest_object = object
        
    def get_closest_object(self):
        return self.closest_object
    
    def set_intersection_point(self, x, y, z):
        self.intersection_point = x,y,z
        
    def get_intersection_point(self):
        return self.intersection_point
    
    def set_ray(self, ray):
        self.ray = ray

    def set_colors(self, r, g, b):
        self.f_color = r, g, b
        
    def get_colors(self):
        return self.f_color
    
    def set_xy(self, x, y):
        self.x = x
        self.y = y
        
    def get_xy(self):
        return self.x, self.y
    
    def get_ray(self):
        return self.ray
    
    def get_t(self):
        return self.t
    
    def set_t(self, t):
        self.t = t
        
    def calculate_intersection_point(self, t):
        x0, y0, z0 = self.ray.get_origin()
        dx, dy, dz = self.ray.get_ray()
        x = x0 + t * dx
        y = y0 + t * dy
        z = z0 + t * dz
        self.intersection_point = x, y, z
        
class Ray:
    def __init__(self, x_o, y_o, z_o,  pixel_i, pixel_j):
        self.origin = (x_o, y_o, z_o)
        self.pixel_i = pixel_i
        self.pixel_j = pixel_j
        self.x = 0
        self.y = 0
        self.z = -1
        self.index = None
        self.rayType = None
        self.reflection_var = None
        
    def convert_to_per(self,fov):
        x_prime = self.pixel_i/ abs(self.z)
        y_prime = (height - self.pixel_j) / abs(self.z)
        k = tan(radians(fov)/2.0)
        self.x = (x_prime - (width/2.0)) * ((k * 2)/width)
        self.y = (y_prime - (height/2.0)) *((k*2)/height) 

    def get_ray(self):
        return self.x, self.y,self.z
    
    def get_index(self):
        return self.index
    
    def set_index(self, i):
        self.index = i
        
    def get_pixel(self):
        return self.pixel_i, self.pixel_j
        
    def get_slope(self):
        dx = self.x - self.origin[0]
        dy = self.y - self.origin[1]
        dz = self.z - self.origin[2]
        return dx, dy, dz
    
    def set_xyz(self, x,y,z):
        self.x = x
        self.y = y
        self.z = z
    
    def set_reflection_dir(self, x, y, z):
        self.reflection_var = x,y,z
        
    def get_reflection_dir(self):
        return self.reflection_var
    
    def get_origin(self):
        return self.origin
    
    def set_ray_type(self, type):
        self.rayType = type
        
    def get_ray_type(self):
        return self.rayType
    